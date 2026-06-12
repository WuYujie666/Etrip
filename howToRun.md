flutter emulators --launch Medium_Phone_API_36.0

# 先开模拟器

flutter run # 再跑项目

# 1. 在 flutter run 的终端里按 q 退出当前 app（彻底停掉，不是热重启）

# 2. 重新跑（会完整重新构建，把新图片打包进去）

flutter run
如果重跑后还是旧图，再加一步清缓存：

flutter clean
flutter pub get
flutter run
