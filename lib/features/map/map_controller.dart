import 'dart:async';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

/// 地图控制器 - 使用 GetX 状态管理
class MapController extends GetxController {
  // Google Map 控制器
  GoogleMapController? mapController;
  
  // 标记集合
  final RxSet<Marker> markers = <Marker>{}.obs;
  
  // 当前位置
  final Rx<Position?> currentPosition = Rx<Position?>(null);
  
  // 地图类型
  final Rx<MapType> mapType = MapType.normal.obs;
  
  // 是否显示交通
  final RxBool trafficEnabled = false.obs;
  
  // 是否显示我的位置
  final RxBool myLocationEnabled = true.obs;
  
  // 选中的标记ID
  final Rx<MarkerId?> selectedMarkerId = Rx<MarkerId?>(null);
  
  // 筛选类型
  final RxString selectedFilter = 'all'.obs; // all, places, activities, events
  
  // 搜索关键词
  final RxString searchQuery = ''.obs;
  
  // 是否正在加载
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkLocationPermission();
  }

  @override
  void onClose() {
    mapController?.dispose();
    super.onClose();
  }

  /// 设置地图控制器
  void setMapController(GoogleMapController controller) {
    mapController = controller;
  }

  /// 检查位置权限
  Future<void> checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      await getCurrentLocation();
    }
  }

  /// 获取当前位置
  Future<void> getCurrentLocation() async {
    try {
      isLoading.value = true;
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      currentPosition.value = position;
      
      // 移动相机到当前位置
      if (mapController != null) {
        await mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 14,
            ),
          ),
        );
      }
    } catch (e) {
      print('Error getting location: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// 移动相机到指定位置
  Future<void> moveToLocation(LatLng target, {double zoom = 15}) async {
    if (mapController != null) {
      await mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: target, zoom: zoom),
        ),
      );
    }
  }

  /// 切换地图类型
  void cycleMapType() {
    final types = MapType.values;
    final currentIndex = types.indexOf(mapType.value);
    mapType.value = types[(currentIndex + 1) % types.length];
  }

  /// 切换交通显示
  void toggleTraffic() {
    trafficEnabled.value = !trafficEnabled.value;
  }

  /// 切换我的位置显示
  void toggleMyLocation() {
    myLocationEnabled.value = !myLocationEnabled.value;
  }

  /// 设置筛选类型
  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  /// 设置搜索关键词
  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  /// 设置选中的标记
  void setSelectedMarker(MarkerId? markerId) {
    selectedMarkerId.value = markerId;
  }

  /// 添加标记
  void addMarker(Marker marker) {
    markers.add(marker);
  }

  /// 清除所有标记
  void clearMarkers() {
    markers.clear();
  }

  /// 更新标记集合
  void updateMarkers(Set<Marker> newMarkers) {
    markers.value = newMarkers;
  }

  /// 根据ID获取标记
  Marker? getMarkerById(MarkerId markerId) {
    try {
      return markers.firstWhere((m) => m.markerId == markerId);
    } catch (e) {
      return null;
    }
  }

  /// 计算两点之间的距离（米）
  double calculateDistance(LatLng start, LatLng end) {
    return Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    );
  }

  /// 获取当前位置到目标位置的距离
  double? getDistanceTo(LatLng target) {
    if (currentPosition.value == null) return null;
    
    return Geolocator.distanceBetween(
      currentPosition.value!.latitude,
      currentPosition.value!.longitude,
      target.latitude,
      target.longitude,
    );
  }

  /// 将距离格式化为可读字符串
  String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.round()} 米';
    } else {
      return '${(distanceInMeters / 1000).toStringAsFixed(1)} 公里';
    }
  }
}
