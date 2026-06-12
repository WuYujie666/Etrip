import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:etrip/core/mock_data.dart';
import 'package:etrip/features/places/data/models/place_model.dart';

/// 交互式地图页面 - 仅展示景点
class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();

  // 当前位置
  LatLng? _currentPosition;
  bool _locationLoading = false;

  /// 默认初始位置（中国中心）
  static const LatLng _defaultCenter = LatLng(35.86, 104.19);
  static const double _defaultZoom = 5;

  /// 用户位置附近的初始缩放
  static const double _userZoom = 10;

  /// 成都中心（备用位置）
  static const LatLng _chengduCenter = LatLng(30.57, 104.07);

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  /// 检查位置权限
  Future<void> _checkLocationPermission() async {
    LocationPermission permission;
    try {
      permission = await Geolocator.checkPermission().timeout(const Duration(seconds: 5));
    } on TimeoutException {
      _useFallbackLocation();
      return;
    }
    if (permission == LocationPermission.denied) {
      try {
        permission = await Geolocator.requestPermission().timeout(const Duration(seconds: 5));
      } on TimeoutException {
        _useFallbackLocation();
        return;
      }
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      _getCurrentLocation();
    } else {
      _useFallbackLocation();
    }
  }

  /// 使用备用位置（成都）
  void _useFallbackLocation() {
    setState(() {
      _currentPosition = _chengduCenter;
      _locationLoading = false;
    });
    _mapController.move(_chengduCenter, _userZoom);
  }

  /// 获取当前位置
  Future<void> _getCurrentLocation() async {
    setState(() => _locationLoading = true);

    // 先尝试获取上次已知位置（更快）
    try {
      final lastPos = await Geolocator.getLastKnownPosition().timeout(const Duration(seconds: 3));
      if (lastPos != null) {
        final pos = LatLng(lastPos.latitude, lastPos.longitude);
        setState(() {
          _currentPosition = pos;
          _locationLoading = false;
        });
        _mapController.move(pos, _userZoom);
        return;
      }
    } catch (_) {}

    // 再尝试获取当前位置（带超时）
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(const Duration(seconds: 10));
      final pos = LatLng(position.latitude, position.longitude);
      setState(() {
        _currentPosition = pos;
        _locationLoading = false;
      });
      _mapController.move(pos, _userZoom);
    } catch (e) {
      debugPrint('Error getting location: $e');
      _useFallbackLocation();
    }
  }

  /// 重置到默认视角（用户位置或中国中心）
  void _resetToDefault() {
    if (_currentPosition != null) {
      _mapController.move(_currentPosition!, _userZoom);
    } else {
      _mapController.move(_defaultCenter, _defaultZoom);
    }
  }

  /// 计算两点间的距离（公里）
  double _distanceBetween(LatLng a, LatLng b) {
    const R = 6371.0; // 地球半径（公里）
    final dLat = (b.latitude - a.latitude) * pi / 180;
    final dLng = (b.longitude - a.longitude) * pi / 180;
    final sinLat = sin(dLat / 2);
    final sinLng = sin(dLng / 2);
    final a2 = sinLat * sinLat +
        cos(a.latitude * pi / 180) * cos(b.latitude * pi / 180) * sinLng * sinLng;
    final c = 2 * atan2(sqrt(a2), sqrt(1 - a2));
    return R * c;
  }

  /// 获取离用户最近的10个景点
  List<MapLocation> _getNearestPlaces() {
    final allLocations = mockPlaces
        .where((p) => p.lat != 0.0 && p.lng != 0.0)
        .map((p) => MapLocation(
              id: p.id,
              name: placeNamesZh[p.id] ?? p.name,
              nameEn: p.name,
              lat: p.lat,
              lng: p.lng,
              rating: p.rate,
              imageUrl: p.profileImage,
              description: placeDescriptionsZh[p.id] ?? p.description,
            ))
        .toList();

    if (_currentPosition == null) {
      return allLocations.take(10).toList();
    }

    allLocations.sort((a, b) {
      final distA = _distanceBetween(_currentPosition!, LatLng(a.lat, a.lng));
      final distB = _distanceBetween(_currentPosition!, LatLng(b.lat, b.lng));
      return distA.compareTo(distB);
    });

    return allLocations.take(10).toList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _defaultCenter,
          initialZoom: _defaultZoom,
          minZoom: 3,
          maxZoom: 18,
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
          ),
          onTap: (_, __) {
          },
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://webrd01.is.autonavi.com/appmaptile?lang=zh_cn&size=1&scale=1&style=8&x={x}&y={y}&z={z}',
            userAgentPackageName: 'com.example.etrip',
            maxZoom: 18,
          ),
          if (_currentPosition != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: _currentPosition!,
                  width: 30,
                  height: 30,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blue, width: 3),
                    ),
                  ),
                ),
              ],
            ),
          MarkerLayer(
            markers: mockPlaces
                .where((p) => p.lat != 0.0 && p.lng != 0.0)
                .map((place) => Marker(
                      point: LatLng(place.lat, place.lng),
                      width: 44,
                      height: 44,
                      child: GestureDetector(
                        onTap: () {
                          _showPlaceDetails(place);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.9),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.place,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'location',
        onPressed: _resetToDefault,
        backgroundColor: Colors.purple,
        child: const Icon(Icons.my_location, color: Colors.white),
      ),
      bottomSheet: _buildNearestPlacesSheet(),
    );
  }

  /// 最近景点底部列表
  Widget _buildNearestPlacesSheet() {
    final nearest = _getNearestPlaces();

    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          // 拖动指示器
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // 标题
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _currentPosition != null ? '最近景点' : '景点列表',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _locationLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        '${nearest.length} 个结果',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // 横向列表
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: nearest.length,
              itemBuilder: (context, index) {
                final location = nearest[index];
                return _PlaceCard(
                  location: location,
                  onTap: () {
                    _mapController.move(
                      LatLng(location.lat, location.lng),
                      16,
                    );
                    // Find the full place and show details
                    final place = mockPlaces.firstWhere(
                      (p) => p.id == location.id,
                    );
                    _showPlaceDetails(place);
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }

  /// 显示景点详情
  void _showPlaceDetails(PlaceModel place) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _PlaceDetailSheet(place: place),
    );
  }
}

/// 位置数据模型（景点用）
class MapLocation {
  final String id;
  final String name;
  final String nameEn;
  final double lat;
  final double lng;
  final double rating;
  final String imageUrl;
  final String description;

  MapLocation({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.lat,
    required this.lng,
    required this.rating,
    required this.imageUrl,
    required this.description,
  });
}

/// 景点卡片
class _PlaceCard extends StatelessWidget {
  final MapLocation location;
  final VoidCallback onTap;

  const _PlaceCard({
    required this.location,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                const Icon(Icons.place, size: 14, color: Colors.red),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    '景点',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, size: 12, color: Colors.amber),
                    const SizedBox(width: 1),
                    Text(
                      location.rating.toString(),
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              location.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              location.nameEn,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

/// 景点详情底部弹窗
class _PlaceDetailSheet extends StatelessWidget {
  final PlaceModel place;

  const _PlaceDetailSheet({required this.place});

  @override
  Widget build(BuildContext context) {
    final nameZh = placeNamesZh[place.id] ?? place.name;
    final descZh = placeDescriptionsZh[place.id] ?? place.description;

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // 拖动指示器
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 图片
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(
                          Icons.place,
                          size: 60,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 名称
                  Text(
                    nameZh,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    place.name,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 评分
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 24),
                      const SizedBox(width: 4),
                      Text(
                        place.rate.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(${place.totalRates} 评价)',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 描述
                  Text(
                    '简介',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    descZh,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 坐标信息
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.grey[600]),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '坐标',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${place.lat.toStringAsFixed(4)}, ${place.lng.toStringAsFixed(4)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
