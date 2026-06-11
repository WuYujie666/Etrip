import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:etrip/core/mock_data.dart';
import 'package:etrip/features/places/data/models/place_model.dart';

/// 交互式地图页面 - 展示景点、活动和事件
class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();

  // 地图标记集合
  final List<Marker> _markers = [];
  final List<CircleMarker> _circles = [];

  // 当前位置
  LatLng? _currentPosition;

  // 是否显示我的位置
  bool _myLocationEnabled = true;

  // 选中的标记ID
  String? _selectedMarkerId;

  // 筛选类型
  String _selectedFilter = 'all'; // all, places, activities, events

  /// 从共享数据源构建地图位置列表
  List<MapLocation> get _locations {
    final list = <MapLocation>[];

    // 从 mockPlaces 转换景点
    for (final place in mockPlaces) {
      if (place.lat == 0.0 && place.lng == 0.0) continue;
      list.add(MapLocation(
        id: place.id,
        name: placeNamesZh[place.id] ?? place.name,
        nameEn: place.name,
        lat: place.lat,
        lng: place.lng,
        type: LocationType.place,
        category: categoriesZh[place.category] ?? place.category,
        rating: place.rate,
        imageUrl: place.profileImage,
        description: placeDescriptionsZh[place.id] ?? place.description,
      ));
    }

    // 从 mockEvents 转换事件
    for (final event in mockEvents) {
      final lat = event['lat'];
      final lng = event['lng'];
      if (lat == null || lng == null) continue;
      final eid = event['event_id']?.toString() ?? '';
      list.add(MapLocation(
        id: 'event_$eid',
        name: eventNamesZh[eid] ?? event['event_name'] ?? '',
        nameEn: event['event_name'] ?? '',
        lat: (lat as double),
        lng: (lng as double),
        type: LocationType.event,
        category: eventTypesZh[event['event_type']?.toString() ?? ''] ?? event['event_type']?.toString() ?? '',
        rating: 4.5,
        imageUrl: event['Image']?.toString() ?? '',
        description: event['event_name']?.toString() ?? '',
      ));
    }

    // 从 mockActivities 转换活动
    for (final activity in mockActivities) {
      final lat = activity['lat'];
      final lng = activity['lng'];
      if (lat == null || lng == null) continue;
      final aid = activity['id']?.toString() ?? '';
      list.add(MapLocation(
        id: 'activity_$aid',
        name: activityTitlesZh[aid] ?? activity['title'] ?? '',
        nameEn: activity['title'] ?? '',
        lat: (lat as double),
        lng: (lng as double),
        type: LocationType.activity,
        category: activityTypesZh[activity['activity_type']?.toString() ?? ''] ?? activity['activity_type']?.toString() ?? '',
        rating: double.tryParse(activity['rating']?.toString() ?? '') ?? 4.5,
        imageUrl: activity['Image']?.toString() ?? '',
        description: activity['title']?.toString() ?? '',
      ));
    }

    // 附加的地图特有位置（不在 mock 数据中）
    list.addAll(_extraLocations);
    return list;
  }

  /// 地图特有的位置（传统节日等活动）
  static final List<MapLocation> _extraLocations = [
    MapLocation(
      id: 'spring_festival',
      name: '春节庙会',
      nameEn: 'Spring Festival Fair',
      lat: 39.9000,
      lng: 116.4000,
      type: LocationType.event,
      category: '传统节日',
      rating: 4.7,
      imageUrl: '',
      description: '体验中国传统春节的热闹庙会',
    ),
    MapLocation(
      id: 'dragon_boat',
      name: '龙舟赛',
      nameEn: 'Dragon Boat Festival',
      lat: 30.3000,
      lng: 120.1800,
      type: LocationType.event,
      category: '传统节日',
      rating: 4.6,
      imageUrl: '',
      description: '端午节的龙舟竞渡，场面壮观',
    ),
    MapLocation(
      id: 'silk_road',
      name: '丝绸之路骑行',
      nameEn: 'Silk Road Cycling',
      lat: 38.0500,
      lng: 114.4800,
      type: LocationType.activity,
      category: '骑行',
      rating: 4.6,
      imageUrl: '',
      description: '沿着古丝绸之路骑行，探索西域文化',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _loadMarkers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// 检查位置权限
  Future<void> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      _getCurrentLocation();
    }
  }

  /// 获取当前位置
  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });

      _mapController.move(
        LatLng(position.latitude, position.longitude),
        14,
      );
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  /// 加载标记
  void _loadMarkers() {
    final filteredLocations = _getFilteredLocations();

    setState(() {
      _markers.clear();

      for (var location in filteredLocations) {
        final marker = Marker(
          point: LatLng(location.lat, location.lng),
          width: 44,
          height: 44,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedMarkerId = location.id;
              });
              _showLocationDetails(location);
            },
            child: Container(
              decoration: BoxDecoration(
                color: _getTypeColor(location.type).withOpacity(0.9),
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
              child: Icon(
                _getTypeIcon(location.type),
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        );

        _markers.add(marker);
      }
    });
  }

  /// 根据筛选条件获取位置列表
  List<MapLocation> _getFilteredLocations() {
    if (_selectedFilter == 'all') {
      return _locations;
    }
    return _locations.where((loc) {
      switch (_selectedFilter) {
        case 'places':
          return loc.type == LocationType.place;
        case 'activities':
          return loc.type == LocationType.activity;
        case 'events':
          return loc.type == LocationType.event;
        default:
          return true;
      }
    }).toList();
  }

  Color _getTypeColor(LocationType type) {
    switch (type) {
      case LocationType.place:
        return Colors.red;
      case LocationType.activity:
        return Colors.green;
      case LocationType.event:
        return Colors.purple;
    }
  }

  IconData _getTypeIcon(LocationType type) {
    switch (type) {
      case LocationType.place:
        return Icons.place;
      case LocationType.activity:
        return Icons.local_activity;
      case LocationType.event:
        return Icons.event;
    }
  }

  /// 显示位置详情
  void _showLocationDetails(MapLocation location) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _LocationDetailSheet(location: location),
    );
  }

  /// 移动到指定位置
  void _moveToLocation(double lat, double lng, {double zoom = 15}) {
    _mapController.move(LatLng(lat, lng), zoom);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: const LatLng(35.86, 104.19),
          initialZoom: 5,
          minZoom: 3,
          maxZoom: 18,
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.all,
          ),
          onTap: (_, __) {
            setState(() {
              _selectedMarkerId = null;
            });
          },
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://webrd01.is.autonavi.com/appmaptile?lang=zh_cn&size=1&scale=1&style=8&x={x}&y={y}&z={z}',
            userAgentPackageName: 'com.example.etrip',
            maxZoom: 18,
          ),
          if (_myLocationEnabled && _currentPosition != null)
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
          MarkerLayer(markers: _markers),
        ],
      ),
      bottomSheet: _buildBottomSheet(),
      floatingActionButton: FloatingActionButton(
        heroTag: 'location',
        onPressed: _getCurrentLocation,
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.my_location, color: Colors.white),
      ),
    );
  }

  /// 筛选芯片
  Widget _buildFilterChips() {
    final filters = [
      {'key': 'all', 'label': '全部', 'icon': Icons.map},
      {'key': 'places', 'label': '景点', 'icon': Icons.place},
      {'key': 'activities', 'label': '活动', 'icon': Icons.local_activity},
      {'key': 'events', 'label': '事件', 'icon': Icons.event},
    ];

    return Container(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter['key'];

          return FilterChip(
            selected: isSelected,
            showCheckmark: false,
            backgroundColor: Colors.white,
            selectedColor: Theme.of(context).primaryColor,
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  filter['icon'] as IconData,
                  size: 16,
                  color: isSelected ? Colors.white : Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  filter['label'] as String,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[800],
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
            onSelected: (_) {
              setState(() {
                _selectedFilter = filter['key'] as String;
                _loadMarkers();
              });
            },
          );
        },
      ),
    );
  }

  /// 图例
  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLegendItem(Colors.red, '景点'),
          const SizedBox(height: 8),
          _buildLegendItem(Colors.green, '活动'),
          const SizedBox(height: 8),
          _buildLegendItem(Colors.purple, '事件'),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  /// 底部列表
  Widget _buildBottomSheet() {
    final filteredLocations = _getFilteredLocations();

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
                  '附近 ${_getFilterLabel()}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${filteredLocations.length} 个结果',
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
              itemCount: filteredLocations.length,
              itemBuilder: (context, index) {
                final location = filteredLocations[index];
                return _LocationCard(
                  location: location,
                  onTap: () {
                    _moveToLocation(location.lat, location.lng, zoom: 16);
                    _showLocationDetails(location);
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

  String _getFilterLabel() {
    switch (_selectedFilter) {
      case 'places':
        return '景点';
      case 'activities':
        return '活动';
      case 'events':
        return '事件';
      default:
        return '地点';
    }
  }
}

/// 位置数据模型
class MapLocation {
  final String id;
  final String name;
  final String nameEn;
  final double lat;
  final double lng;
  final LocationType type;
  final String category;
  final double rating;
  final String imageUrl;
  final String description;

  MapLocation({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.lat,
    required this.lng,
    required this.type,
    required this.category,
    required this.rating,
    required this.imageUrl,
    required this.description,
  });
}

enum LocationType { place, activity, event }

/// 位置卡片
class _LocationCard extends StatelessWidget {
  final MapLocation location;
  final VoidCallback onTap;

  const _LocationCard({
    required this.location,
    required this.onTap,
  });

  Color _getTypeColor() {
    switch (location.type) {
      case LocationType.place:
        return Colors.red;
      case LocationType.activity:
        return Colors.green;
      case LocationType.event:
        return Colors.purple;
    }
  }

  IconData _getTypeIcon() {
    switch (location.type) {
      case LocationType.place:
        return Icons.place;
      case LocationType.activity:
        return Icons.local_activity;
      case LocationType.event:
        return Icons.event;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: _getTypeColor().withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _getTypeColor().withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(_getTypeIcon(), size: 14, color: _getTypeColor()),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getTypeColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    location.category,
                    style: TextStyle(
                      color: _getTypeColor(),
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

/// 位置详情底部弹窗
class _LocationDetailSheet extends StatelessWidget {
  final MapLocation location;

  const _LocationDetailSheet({required this.location});

  Color _getTypeColor() {
    switch (location.type) {
      case LocationType.place:
        return Colors.red;
      case LocationType.activity:
        return Colors.green;
      case LocationType.event:
        return Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      child: Center(
                        child: Icon(
                          location.type == LocationType.place
                              ? Icons.place
                              : location.type == LocationType.activity
                                  ? Icons.local_activity
                                  : Icons.event,
                          size: 60,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 类型标签
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getTypeColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      location.category,
                      style: TextStyle(
                        color: _getTypeColor(),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 名称
                  Text(
                    location.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // 英文名
                  Text(
                    location.nameEn,
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
                        location.rating.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(2,847 评价)',
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
                    location.description,
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
                                '${location.lat.toStringAsFixed(4)}, ${location.lng.toStringAsFixed(4)}',
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

                  // 操作按钮
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('已将 ${location.name} 添加到行程')),
                            );
                          },
                          icon: const Icon(Icons.add_location),
                          label: const Text('添加到行程'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('已将 ${location.name} 添加到收藏')),
                            );
                          },
                          icon: const Icon(Icons.favorite_border),
                          label: const Text('收藏'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // 导航按钮
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.directions),
                      label: const Text('开始导航'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

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
