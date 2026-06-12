# Feature Documentation

> 本文档记录本项目中关键功能的技术细节，便于快速回顾项目结构。
> 最后更新: 2026-06-11

---

## 1. 地图功能 (Map)

### 文件位置
- `lib/features/map/map_screen.dart` — 主页面 + 所有子组件（卡片、详情弹窗）
- `lib/core/mock_data.dart` — 共享数据源（景点/事件/活动）

### 技术栈
- **flutter_map ^7.0.0** — 地图组件（替代 google_maps_flutter）
- **latlong2 ^0.9.0** — 经纬度数据类型（`LatLng`）
- **高德地图瓦片** — 在中国可用的地图瓦片服务
- **geolocator ^14.0.0** — 获取设备位置

### 核心结构

```
Scaffold
├── body: FlutterMap (手势交互)
│   ├── TileLayer (高德地图瓦片)
│   ├── MarkerLayer (当前位置标记)
│   └── MarkerLayer (景点/事件/活动标记)
├── bottomSheet: 底部附近地点列表
└── floatingActionButton: 定位按钮
```

### 数据模型
```dart
class MapLocation {
  String id, name, nameEn, category, imageUrl, description;
  double lat, lng, rating;
  LocationType type; // place | activity | event
}
```

### 数据同步
地图不再使用硬编码数据，而是从 `mock_data.dart` 读取：
- `mockPlaces` → `MapLocation(type: place)` — 16个中国景点
- `mockEvents` → `MapLocation(type: event)` — 7个事件  
- `mockActivities` → `MapLocation(type: activity)` — 7个活动
- `_extraLocations` — 地图特有的3个条目（春节庙会、龙舟赛、丝绸之路骑行）

**关键变量/常量：**
- `mockPlaces` (mock_data.dart:8) — 景点列表，已添加 `lat`/`lng`
- `placeNamesZh` — 景点中文名映射
- `placeDescriptionsZh` — 景点中文描述
- `eventNamesZh` — 事件中文名映射
- `activityTitlesZh` — 活动中文名映射

### 手势冲突解决方案
`FlutterMap` 不能和 `Stack` 中的 `Positioned` 覆盖层组件放在同级的 `Stack` 中，否则手势无法响应。最终采用方案：
- **body**: 直接放 `FlutterMap`（不用 Stack 包裹）
- **bottomSheet**: 用 `Scaffold.bottomSheet`
- **floatingActionButton**: 用 `Scaffold.floatingActionButton`
- **搜索栏/筛选器/图例**: 用 `Scaffold.appBar` 或其他分离方式

### 颜色约定
- 景点 (place) → 红色
- 活动 (activity) → 绿色
- 事件 (event) → 紫色

---

## 2. 本地认证系统 (Auth)

### 文件位置
- `lib/features/auth/data/services/local_storage_service.dart` — Hive 存储服务
- `lib/features/auth/domain/respotireis/auth_repo.dart` — 仓库接口
- `lib/features/auth/data/respotireis/auth_repo_impl.dart` — 仓库实现
- `lib/features/auth/data/services/firestore_user_service.dart` — 用户资料CRUD

### 技术栈
- **Hive ^2.2.3** — 本地 NoSQL 数据库
- **flutter_bloc ^9.1.0** — 状态管理

### 为什么用本地存储
Firebase 在中国被屏蔽，无法连接。改用 Hive 将用户数据存储在设备本地。

### Hive Boxes
| Box Name | 用途 |
|----------|------|
| `local_users` | 存储用户资料（id, name, email, password等） |
| `local_credentials` | 存储登录凭证（email → password 映射） |
| `local_session` | 存储当前登录状态（current_uid） |

### 关键方法
```dart
LocalStorageService()
  .register(name, email, password) → EgyptopiaUser
  .login(email, password) → EgyptopiaUser?
  .logout()
  .changePassword(email, oldPwd, newPwd) → bool
  .getUserProfile(uid) → EgyptopiaUser?
  .updateUserProfile(uid, data) → bool
  .currentUid → String?  // 当前登录用户ID
  .isLoggedIn → bool      // 是否已登录
```

### 用户模型
```dart
class EgyptopiaUser {
  String id, name, email, country, dateOfBirth, gender;
  String? profileImg;
  List<String> preferredCategories, preferredTourismTypes, preferredCities;
}
```
文件: `lib/features/auth/data/models/egyptopia_user.dart`

---

## 3. 国际化/本地化 (i18n)

### 文件位置
- `lib/core/localization/translations.dart` — 翻译键值对
- `lib/core/localization/locale_cubit.dart` — 语言状态管理
- `lib/core/localization/locale_states.dart` — 语言状态

### 技术栈
- **flutter_bloc** — LocaleCubit 管理语言状态
- **Hive** — 持久化语言偏好

### 使用方法
```dart
Translations.tr('key', languageCode) // 返回翻译文本
```

### 语言
- `en` — 英语
- `zh` — 中文

### 键命名规则
- 首页: `recommended_for_you`, `top_places`, `all_places`, `error`
- 认证相关: `login_required_activities`, `login_required_weather`, `login_required_chatbot`
- 通用: `places`, `events`, `activities`, `weather`, `chatbot`, `map`

---

## 4. 数据层 (Mock Data)

### 文件位置
- `lib/core/mock_data.dart` — 所有模拟数据 + 中文翻译映射

### 数据结构

**PlaceModel** (景点) — 16个中国景点:
```dart
PlaceModel {
  id, name, profileImage, carouselImages, tourismType,
  category, cityName, rate, totalRates, description,
  googleMapsLink, lat, lng  // lat/lng 已添加用于地图
}
```

**mockEvents** (事件) — 7个事件，`List<Map<String, dynamic>>`:
- 键: `event_id`, `event_name`, `Image`, `event_date`, `event_type`, `city_name`, `event_time`, `ticket_price`, `registration_link`, `lat`, `lng`

**mockActivities** (活动) — 7个活动，`List<Map<String, dynamic>>`:
- 键: `id`, `title`, `Image`, `activity_type`, `city_name`, `price_before`, `price_after`, `rating`, `link`, `lat`, `lng`

### 中文翻译映射表
| 映射表 | 用途 |
|--------|------|
| `placeNamesZh` | 景点中文名 |
| `placeDescriptionsZh` | 景点中文描述 |
| `cityNamesZh` | 城市中文名 |
| `eventNamesZh` | 事件中文名 |
| `activityTitlesZh` | 活动中文名 |
| `categoriesZh` | 分类中文名 |
| `tourismTypesZh` | 旅游类型中文名 |

---

## 5. 路由系统

### 文件位置
- `lib/core/utils/app_router.dart`

### 技术栈
- **go_router ^14.8.0** — 声明式路由

### 路由列表
| Route | 页面 |
|-------|------|
| `/` | Splash |
| `/home` | Home (ShellRoute) |
| `/signIn` | Sign In |
| `/signUp` | Sign Up |
| `/places` | Places |
| `/placeDetails` | Place Details |
| `/events` | Events |
| `/eventDetails` | Event Details |
| `/activities` | Activities |
| `/weather` | Weather |
| `/chatbot` | Chatbot |
| `/profile` | Profile |
| `/map` | Map Screen |

### 路由常量命名
```dart
AppRouter.kHome, AppRouter.kPlaces, AppRouter.kEvents,
AppRouter.kActivities, AppRouter.kWeather, AppRouter.kChatbot,
AppRouter.kMap, AppRouter.kPlaceDetails, AppRouter.kEventDetails,
```

---

## 6. 依赖 (pubspec.yaml 关键包)

| 包名 | 版本 | 用途 |
|------|------|------|
| flutter_map | ^7.0.0 | 地图 |
| latlong2 | ^0.9.0 | 地理坐标 |
| geolocator | ^14.0.0 | GPS定位 |
| hive | ^2.2.3 | 本地存储 |
| hive_flutter | ^1.1.0 | Hive Flutter支持 |
| go_router | ^14.8.0 | 路由 |
| flutter_bloc | ^9.1.0 | 状态管理 |
| bloc | ^9.0.0 | BLoC核心 |
| dartz | ^0.10.1 | 函数式编程 |
| google_fonts | ^6.2.1 | 字体 |
| font_awesome_flutter | ^10.8.0 | 图标 |
| url_launcher | ^6.2.5 | 打开链接 |
| intl | ^0.20.2 | 国际化 |
| cached_network_image | ^3.4.1 | 图片缓存 |

---

## 提醒

1. **FlutterMap 手势限制**: 不能在 `Stack` 中和 `Positioned` 覆盖层同级，会阻止拖动/缩放
2. **所有数据都是 Mock**: 没有真实的 API 后端，`PlacesApiService` 中的延迟和 `fromJson` 是为了未来接入真实 API 预留的
3. **Kotlin 版本**: 当前 1.8.22，Flutter 提示未来版本将需要 2.1.0+
4. **Impeller 渲染**: 该设备使用 Vulkan + Impeller 渲染
