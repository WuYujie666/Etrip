import 'package:etrip/features/auth/data/models/egyptopia_user.dart';
import 'package:etrip/features/places/data/models/place_model.dart';

const _places = 'assets/images/places';

// ============ Mock Places ============

final List<PlaceModel> mockPlaces = [
  PlaceModel(
    id: '1',
    name: 'Great Wall',
    profileImage: '$_places/great_wall.jpg',
    carouselImages: [
      '$_places/great_wall.jpg',
    ],
    tourismType: 'Cultural and Historical Attractions',
    category: 'historical site',
    cityName: 'Beijing',
    rate: 4.9,
    totalRates: 23500,
    description:
        'The Great Wall of China is one of the most iconic wonders of the world, stretching over 13,000 miles. '
        'Built across multiple dynasties, it offers breathtaking views and a glimpse into China\'s ancient history.',
    googleMapsLink: 'https://maps.google.com/?q=Great+Wall+of+China',
  ),
  PlaceModel(
    id: '2',
    name: 'Forbidden City',
    profileImage: '$_places/forbidden_city.jpg',
    carouselImages: [
      '$_places/forbidden_city.jpg',
    ],
    tourismType: 'Cultural and Historical Attractions',
    category: 'palace',
    cityName: 'Beijing',
    rate: 4.8,
    totalRates: 18200,
    description:
        'The Forbidden City was the Chinese imperial palace from the Ming to the Qing dynasty. '
        'It houses over 1 million artifacts and is the world\'s largest palace complex.',
    googleMapsLink: 'https://maps.google.com/?q=Forbidden+City+Beijing',
  ),
  PlaceModel(
    id: '3',
    name: 'The Bund',
    profileImage: '$_places/the_bund.jpg',
    carouselImages: [
      '$_places/the_bund.jpg',
    ],
    tourismType: 'Entertainment and Modern Attractions',
    category: 'shopping',
    cityName: 'Shanghai',
    rate: 4.5,
    totalRates: 15400,
    description:
        'The Bund is Shanghai\'s iconic waterfront promenade, lined with colonial-era buildings '
        'and modern skyscrapers. It offers spectacular views of the Huangpu River and Pudong skyline.',
    googleMapsLink: 'https://maps.google.com/?q=The+Bund+Shanghai',
  ),
  PlaceModel(
    id: '4',
    name: 'Leshan Giant Buddha',
    profileImage: '$_places/leshan_buddha.jpg',
    carouselImages: [
      '$_places/leshan_buddha.jpg',
    ],
    tourismType: 'Religious and Spiritual Attractions',
    category: 'historical site',
    cityName: 'Leshan',
    rate: 4.7,
    totalRates: 8600,
    description:
        'The Leshan Giant Buddha is a 71-meter tall stone statue carved into a cliff face. '
        'Built during the Tang dynasty, it is the largest stone Buddha in the world.',
    googleMapsLink: 'https://maps.google.com/?q=Leshan+Giant+Buddha',
  ),
  PlaceModel(
    id: '5',
    name: 'Zhangjiajie National Forest',
    profileImage: '$_places/zhangjiajie.jpg',
    carouselImages: [
      '$_places/zhangjiajie.jpg',
    ],
    tourismType: 'Natural Attractions',
    category: 'historical site',
    cityName: 'Zhangjiajie',
    rate: 4.8,
    totalRates: 12600,
    description:
        'Zhangjiajie National Forest Park is famous for its towering sandstone pillars, '
        'which inspired the floating mountains in Avatar. It offers stunning hiking trails and glass bridges.',
    googleMapsLink: 'https://maps.google.com/?q=Zhangjiajie+National+Forest',
  ),
  PlaceModel(
    id: '6',
    name: 'Terracotta Warriors',
    profileImage: '$_places/terracotta.jpg',
    carouselImages: [
      '$_places/terracotta.jpg',
    ],
    tourismType: 'Cultural and Historical Attractions',
    category: 'museum',
    cityName: "Xi'an",
    rate: 4.8,
    totalRates: 16800,
    description:
        'The Terracotta Army is a collection of thousands of life-sized clay soldiers buried with Emperor Qin. '
        'Discovered in 1974, it is considered the eighth wonder of the world.',
    googleMapsLink: 'https://maps.google.com/?q=Terracotta+Warriors+Xian',
  ),
  PlaceModel(
    id: '7',
    name: 'West Lake',
    profileImage: '$_places/west_lake.jpg',
    carouselImages: [
      '$_places/west_lake.jpg',
    ],
    tourismType: 'Natural Attractions',
    category: 'garden',
    cityName: 'Hangzhou',
    rate: 4.7,
    totalRates: 14500,
    description:
        'West Lake is a UNESCO World Heritage site in Hangzhou, known for its natural beauty '
        'and historic pagodas. It has inspired poets and artists for centuries.',
    googleMapsLink: 'https://maps.google.com/?q=West+Lake+Hangzhou',
  ),
  PlaceModel(
    id: '8',
    name: 'Potala Palace',
    profileImage: '$_places/potala_palace.jpg',
    carouselImages: [
      '$_places/potala_palace.jpg',
    ],
    tourismType: 'Religious and Spiritual Attractions',
    category: 'palace',
    cityName: 'Lhasa',
    rate: 4.8,
    totalRates: 9200,
    description:
        'The Potala Palace in Lhasa was the winter residence of the Dalai Lama. '
        'This stunning 13-story palace features over 1,000 rooms with beautiful Tibetan Buddhist art.',
    googleMapsLink: 'https://maps.google.com/?q=Potala+Palace+Lhasa',
  ),
  PlaceModel(
    id: '9',
    name: 'Li River',
    profileImage: '$_places/li_river.jpg',
    carouselImages: [
      '$_places/li_river.jpg',
    ],
    tourismType: 'Natural Attractions',
    category: 'historical site',
    cityName: 'Guilin',
    rate: 4.7,
    totalRates: 11300,
    description:
        'The Li River cruise from Guilin to Yangshuo offers some of China\'s most spectacular scenery, '
        'with dramatic karst mountains reflected in the emerald water.',
    googleMapsLink: 'https://maps.google.com/?q=Li+River+Guilin',
  ),
  PlaceModel(
    id: '10',
    name: 'Summer Palace',
    profileImage: '$_places/summer_palace.jpg',
    carouselImages: [
      '$_places/summer_palace.jpg',
    ],
    tourismType: 'Cultural and Historical Attractions',
    category: 'palace',
    cityName: 'Beijing',
    rate: 4.6,
    totalRates: 13100,
    description:
        'The Summer Palace is a magnificent ensemble of lakes, gardens and palaces in Beijing. '
        'It served as a royal retreat and is a masterpiece of Chinese landscape design.',
    googleMapsLink: 'https://maps.google.com/?q=Summer+Palace+Beijing',
  ),
  PlaceModel(
    id: '11',
    name: 'Shanghai Disneyland',
    profileImage: '$_places/disneyland.jpg',
    carouselImages: [
      '$_places/disneyland.jpg',
    ],
    tourismType: 'Entertainment and Modern Attractions',
    category: 'shopping',
    cityName: 'Shanghai',
    rate: 4.6,
    totalRates: 17800,
    description:
        'Shanghai Disneyland is a world-class theme park with unique attractions blending '
        'Disney magic with Chinese culture, including the Enchanted Storybook Castle.',
    googleMapsLink: 'https://maps.google.com/?q=Shanghai+Disneyland',
  ),
  PlaceModel(
    id: '12',
    name: 'Chengdu Panda Base',
    profileImage: '$_places/panda_base.jpg',
    carouselImages: [
      '$_places/panda_base.jpg',
    ],
    tourismType: 'Entertainment and Modern Attractions',
    category: 'garden',
    cityName: 'Chengdu',
    rate: 4.8,
    totalRates: 14100,
    description:
        'The Chengdu Research Base of Giant Panda Breeding lets visitors see giant pandas up close '
        'in a natural setting. It\'s one of the most popular wildlife attractions in China.',
    googleMapsLink: 'https://maps.google.com/?q=Chengdu+Panda+Base',
  ),
  PlaceModel(
    id: '13',
    name: 'Shaolin Temple',
    profileImage: '$_places/shaolin.jpg',
    carouselImages: [
      '$_places/shaolin.jpg',
    ],
    tourismType: 'Religious and Spiritual Attractions',
    category: 'temple',
    cityName: 'Zhengzhou',
    rate: 4.5,
    totalRates: 7800,
    description:
        'Shaolin Temple is the birthplace of Chan (Zen) Buddhism and Shaolin Kung Fu. '
        'Located at Songshan Mountain, it attracts martial arts enthusiasts from around the world.',
    googleMapsLink: 'https://maps.google.com/?q=Shaolin+Temple',
  ),
  PlaceModel(
    id: '14',
    name: 'Yellow Mountain',
    profileImage: '$_places/huangshan.jpg',
    carouselImages: [
      '$_places/huangshan.jpg',
    ],
    tourismType: 'Natural Attractions',
    category: 'historical site',
    cityName: 'Huangshan',
    rate: 4.8,
    totalRates: 10500,
    description:
        'Huangshan, the Yellow Mountain, is renowned for its magnificent granite peaks, '
        'hot springs, and seas of clouds. It\'s one of China\'s most famous scenic areas.',
    googleMapsLink: 'https://maps.google.com/?q=Yellow+Mountain+Huangshan',
  ),
  PlaceModel(
    id: '15',
    name: 'Mogao Caves',
    profileImage: '$_places/mogao_caves.jpg',
    carouselImages: [
      '$_places/mogao_caves.jpg',
    ],
    tourismType: 'Cultural and Historical Attractions',
    category: 'museum',
    cityName: 'Dunhuang',
    rate: 4.6,
    totalRates: 6400,
    description:
        'The Mogao Caves are a UNESCO World Heritage site featuring hundreds of Buddhist cave temples '
        'filled with exquisite murals and sculptures spanning over 1,000 years.',
    googleMapsLink: 'https://maps.google.com/?q=Mogao+Caves+Dunhuang',
  ),
  PlaceModel(
    id: '16',
    name: 'Victoria Harbour',
    profileImage: '$_places/victoria_harbour.jpg',
    carouselImages: [
      '$_places/victoria_harbour.jpg',
    ],
    tourismType: 'Entertainment and Modern Attractions',
    category: 'shopping',
    cityName: 'Hong Kong',
    rate: 4.7,
    totalRates: 19200,
    description:
        'Victoria Harbour is a major attraction in Hong Kong, famous for its stunning skyline '
        'and the Symphony of Lights show. The Star Ferry offers a classic harbour crossing.',
    googleMapsLink: 'https://maps.google.com/?q=Victoria+Harbour+Hong+Kong',
  ),
];

// ============ Mock Events ============

final List<Map<String, dynamic>> mockEvents = [
  {
    'event_id': '1',
    'event_name': 'Shanghai International Film Festival',
    'Image': '$_places/film_festival.jpg',
    'event_date': '15 Jun 2026',
    'event_type': 'Cultural',
    'city_name': 'Shanghai',
    'event_time': '7:00 PM',
    'ticket_price': '280',
    'registration_link': 'https://example.com/shanghaifilm',
  },
  {
    'event_id': '2',
    'event_name': 'Beijing Jazz Festival',
    'Image': '$_places/jazz_festival.jpg',
    'event_date': '20-22 Jul 2026',
    'event_type': 'Music',
    'city_name': 'Beijing',
    'event_time': '6:00 PM',
    'ticket_price': '380',
    'registration_link': 'https://example.com/beijingjazz',
  },
  {
    'event_id': '3',
    'event_name': 'Chengdu Food Festival',
    'Image': '$_places/food_festival.jpg',
    'event_date': '10 Aug 2026',
    'event_type': 'Food',
    'city_name': 'Chengdu',
    'event_time': '10:00 AM',
    'ticket_price': '120',
    'registration_link': 'https://example.com/chengdufood',
  },
  {
    'event_id': '4',
    'event_name': 'Guilin International Music Festival',
    'Image': '$_places/music_festival.jpg',
    'event_date': '15 Sep 2026',
    'event_type': 'Music',
    'city_name': 'Guilin',
    'event_time': '4:00 PM',
    'ticket_price': '200',
    'registration_link': 'https://example.com/guilinmusic',
  },
  {
    'event_id': '5',
    'event_name': 'Xi\'an Cultural Heritage Expo',
    'Image': '$_places/heritage_expo.jpg',
    'event_date': '5 Oct 2026',
    'event_type': 'Cultural',
    'city_name': "Xi'an",
    'event_time': '9:00 AM',
    'ticket_price': '150',
    'registration_link': 'https://example.com/xianexpo',
  },
];

// ============ Mock Activities ============

final List<Map<String, dynamic>> mockActivities = [
  {
    'id': '1',
    'title': 'Li River Bamboo Rafting',
    'Image': '$_places/bamboo_raft.jpg',
    'activity_type': 'Safari',
    'city_name': 'Guilin',
    'price_before': '800',
    'price_after': '500',
    'rating': '4.8',
    'link': 'https://example.com/liriver',
  },
  {
    'id': '2',
    'title': 'Hot Air Balloon over Yangshuo',
    'Image': '$_places/hot_air_balloon.jpg',
    'activity_type': 'Balloon Tours',
    'city_name': 'Yangshuo',
    'price_before': '1500',
    'price_after': '980',
    'rating': '4.9',
    'link': 'https://example.com/yangshuo',
  },
  {
    'id': '3',
    'title': 'Great Wall Hiking Adventure',
    'Image': '$_places/great_wall_hike.jpg',
    'activity_type': 'Safari',
    'city_name': 'Beijing',
    'price_before': '600',
    'price_after': '350',
    'rating': '4.7',
    'link': 'https://example.com/greatwallhike',
  },
  {
    'id': '4',
    'title': 'Huangshan Mountain Trek',
    'Image': '$_places/huangshan_trek.jpg',
    'activity_type': 'Safari',
    'city_name': 'Huangshan',
    'price_before': '1200',
    'price_after': '800',
    'rating': '4.8',
    'link': 'https://example.com/huangshan',
  },
  {
    'id': '5',
    'title': 'Panda Volunteering in Chengdu',
    'Image': '$_places/panda_volunteer.jpg',
    'activity_type': 'Swimming With Dolphins',
    'city_name': 'Chengdu',
    'price_before': '1000',
    'price_after': '600',
    'rating': '4.9',
    'link': 'https://example.com/pandavolunteer',
  },
  {
    'id': '6',
    'title': 'Zhangjiajie Glass Bridge Walk',
    'Image': '$_places/glass_bridge.jpg',
    'activity_type': 'Balloon Tours',
    'city_name': 'Zhangjiajie',
    'price_before': '500',
    'price_after': '300',
    'rating': '4.6',
    'link': 'https://example.com/glassbridge',
  },
];

// ============ Mock User ============

final EgyptopiaUser mockUser = EgyptopiaUser(
  id: 'mock-user-001',
  name: 'Zhang Wei',
  email: 'zhangwei@example.com',
  country: 'China',
  dateOfBirth: '1998-05-15',
  gender: 'male',
  profileImg: null,
  preferredCategories: ['museum', 'historical site', 'palace'],
  preferredTourismTypes: [
    'Cultural and Historical Attractions',
    'Natural Attractions',
  ],
  preferredCities: ['Beijing', 'Shanghai', "Xi'an"],
);

// ============ Mock Itinerary Helpers ============

/// Returns a subset of places for the itinerary plan.
Map<int, List<PlaceModel>> getMockItineraryPlan(int noOfDays) {
  final plan = <int, List<PlaceModel>>{};
  for (int day = 1; day <= noOfDays; day++) {
    final startIndex = ((day - 1) * 2) % mockPlaces.length;
    final endIndex = (startIndex + 2) % mockPlaces.length;
    if (endIndex > startIndex) {
      plan[day] = mockPlaces.sublist(startIndex, endIndex);
    } else {
      plan[day] = [
        mockPlaces[startIndex],
        mockPlaces[(startIndex + 1) % mockPlaces.length],
      ];
    }
  }
  return plan;
}

/// Chinese descriptions for mock places, keyed by place ID.
final Map<String, String> placeDescriptionsZh = {
  '1': '中国长城是世界最著名的奇迹之一，全长超过13,000英里。'
      '历经多个朝代修建，它提供了令人叹为观止的景色，让人一窥中国古代历史。',
  '2': '故宫是中国明清两代的皇家宫殿。'
      '它收藏了超过100万件文物，是世界上最大的宫殿建筑群。',
  '3': '外滩是上海标志性的滨江长廊，两旁排列着殖民时期的建筑'
      '和现代摩天大楼。可以欣赏到黄浦江和浦东天际线的壮观景色。',
  '4': '乐山大佛是一尊高达71米的石雕佛像，雕刻在悬崖峭壁上。'
      '建于唐代，是世界上最大的石刻佛像。',
  '5': '张家界国家森林公园以其高耸的砂岩柱而闻名，'
      '这些石柱曾是电影《阿凡达》中悬浮山的灵感来源。这里有绝佳的徒步路线和玻璃桥。',
  '6': '兵马俑是成千上万等身大小的陶俑，与秦始皇一同埋葬。'
      '于1974年被发现，被誉为世界第八大奇迹。',
  '7': '西湖是杭州的一处联合国教科文组织世界遗产，以其自然美景'
      '和历史悠久的宝塔而闻名。数百年来一直激发着诗人和艺术家的灵感。',
  '8': '拉萨的布达拉宫曾是达赖喇嘛的冬季宫殿。'
      '这座令人惊叹的13层宫殿拥有超过1,000个房间，装饰着精美的藏传佛教艺术品。',
  '9': '从桂林到阳朔的漓江游船展现了中国最壮观的景色，'
      '翠绿的江面倒映着奇特的喀斯特山峰。',
  '10': '颐和园是北京一处集湖泊、园林和宫殿于一体的宏伟建筑群。'
      '它曾是皇家避暑胜地，是中国园林设计的杰作。',
  '11': '上海迪士尼乐园是世界级主题公园，拥有融合迪士尼魔法'
      '与中国文化的独特景点，包括奇幻童话城堡。',
  '12': '成都大熊猫繁育研究基地让游客在自然环境中近距离观赏大熊猫。'
      '它是中国最受欢迎的野生动物景点之一。',
  '13': '少林寺是禅宗佛教和少林功夫的发源地。'
      '位于嵩山，吸引着来自世界各地的武术爱好者。',
  '14': '黄山以其壮丽的花岗岩山峰、温泉和云海而闻名。'
      '它是中国最著名的风景区之一。',
  '15': '莫高窟是联合国教科文组织世界遗产，拥有数百个佛教石窟寺，'
      '内有精美的壁画和雕塑，跨越一千多年。',
  '16': '维多利亚港是香港的主要景点，以其 stunning 的天际线'
      '和幻彩咏香江灯光秀而闻名。天星小轮提供经典的海港渡轮体验。',
};

// ============ Chinese Translations for Mock Data ============

/// Chinese place names keyed by place ID.
final Map<String, String> placeNamesZh = {
  '1': '长城',
  '2': '故宫',
  '3': '外滩',
  '4': '乐山大佛',
  '5': '张家界国家森林公园',
  '6': '兵马俑',
  '7': '西湖',
  '8': '布达拉宫',
  '9': '漓江',
  '10': '颐和园',
  '11': '上海迪士尼乐园',
  '12': '成都大熊猫基地',
  '13': '少林寺',
  '14': '黄山',
  '15': '莫高窟',
  '16': '维多利亚港',
};

/// Chinese city names keyed by English name.
final Map<String, String> cityNamesZh = {
  'Beijing': '北京',
  'Shanghai': '上海',
  'Leshan': '乐山',
  'Zhangjiajie': '张家界',
  "Xi'an": '西安',
  'Hangzhou': '杭州',
  'Lhasa': '拉萨',
  'Guilin': '桂林',
  'Huangshan': '黄山',
  'Dunhuang': '敦煌',
  'Hong Kong': '香港',
  'Chengdu': '成都',
  'Zhengzhou': '郑州',
  'Yangshuo': '阳朔',
};

/// Chinese event names keyed by event_id.
final Map<String, String> eventNamesZh = {
  '1': '上海国际电影节',
  '2': '北京爵士音乐节',
  '3': '成都美食节',
  '4': '桂林国际音乐节',
  '5': "西安文化遗产博览会",
};

/// Chinese activity titles keyed by activity id.
final Map<String, String> activityTitlesZh = {
  '1': '漓江竹筏漂流',
  '2': '阳朔热气球之旅',
  '3': '长城徒步探险',
  '4': '黄山登山之旅',
  '5': '成都大熊猫志愿者',
  '6': '张家界玻璃桥漫步',
};

/// Chinese event types.
final Map<String, String> eventTypesZh = {
  'Cultural': '文化',
  'Music': '音乐',
  'Food': '美食',
};

/// Chinese activity types.
final Map<String, String> activityTypesZh = {
  'Safari': '探险',
  'Balloon Tours': '热气球',
  'Swimming With Dolphins': '与海豚同游',
};

/// Chinese tourism types keyed by English value.
final Map<String, String> tourismTypesZh = {
  'Cultural and Historical Attractions': '文化与历史景点',
  'Natural Attractions': '自然景观',
  'Entertainment and Modern Attractions': '娱乐与现代景点',
  'Religious and Spiritual Attractions': '宗教与精神景点',
  'Medical Attractions': '医疗旅游',
};

/// Chinese category names keyed by English category value.
final Map<String, String> categoriesZh = {
  'library': '图书馆',
  'museum': '博物馆',
  'theater': '剧院',
  'garden': '园林',
  'fortress': '堡垒',
  'mosque': '清真寺',
  'tower': '塔',
  'palace': '宫殿',
  'tomb': '陵墓',
  'shopping': '购物',
  'zoo': '动物园',
  'synagogue': '犹太教堂',
  'historical site': '历史遗址',
  'temple': '寺庙',
  'aquarium': '水族馆',
  'church': '教堂',
};

// ============ Helper Functions ============

String localizedPlaceName(PlaceModel place, String lang) {
  if (lang == 'zh') return placeNamesZh[place.id] ?? place.name;
  return place.name;
}

String localizedCityName(String cityName, String lang) {
  if (lang == 'zh') return cityNamesZh[cityName] ?? cityName;
  return cityName;
}

String localizedTourismType(String tourismType, String lang) {
  if (lang == 'zh') return tourismTypesZh[tourismType] ?? tourismType;
  return tourismType;
}

String localizedCategory(String category, String lang) {
  if (lang == 'zh') return categoriesZh[category] ?? category;
  return category;
}

String localizedEventName(Map<String, dynamic> event, String lang) {
  if (lang == 'zh') {
    return eventNamesZh[event['event_id']?.toString()] ?? event['event_name'] ?? '';
  }
  return event['event_name'] ?? '';
}

String localizedEventType(String type, String lang) {
  if (lang == 'zh') return eventTypesZh[type] ?? type;
  return type;
}

String localizedActivityTitle(Map<String, dynamic> activity, String lang) {
  if (lang == 'zh') {
    return activityTitlesZh[activity['id']?.toString()] ?? activity['title'] ?? '';
  }
  return activity['title'] ?? '';
}

String localizedActivityType(String type, String lang) {
  if (lang == 'zh') return activityTypesZh[type] ?? type;
  return type;
}
