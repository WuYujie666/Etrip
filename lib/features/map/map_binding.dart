import 'package:get/get.dart';
import 'map_controller.dart';

/// 地图模块依赖注入
class MapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MapController>(() => MapController());
  }
}
