import 'package:egyptopia/features/auth/data/models/egyptopia_user.dart';
import 'package:egyptopia/features/places/data/models/place_model.dart';

const _img = 'https://picsum.photos/seed';

// ============ Mock Places ============

final List<PlaceModel> mockPlaces = [
  PlaceModel(
    id: '1',
    name: 'Pyramids of Giza',
    profileImage: '$_img/pyramids/400/300',
    carouselImages: [
      '$_img/pyramids1/400/300',
      '$_img/pyramids2/400/300',
      '$_img/pyramids3/400/300',
    ],
    tourismType: 'Cultural and Historical Attractions',
    category: 'historical site',
    cityName: 'Giza',
    rate: 4.9,
    totalRates: 12500,
    description:
        'The Pyramids of Giza are iconic ancient wonders of the world, built over 4,500 years ago. '
        'They include the Great Pyramid of Khufu, the Pyramid of Khafre, and the Pyramid of Menkaure. '
        'Visitors can explore the surrounding complex including the Great Sphinx.',
    googleMapsLink: 'https://maps.google.com/?q=Pyramids+of+Giza',
  ),
  PlaceModel(
    id: '2',
    name: 'Egyptian Museum',
    profileImage: '$_img/egyptianmuseum/400/300',
    carouselImages: [
      '$_img/egyptianmuseum1/400/300',
      '$_img/egyptianmuseum2/400/300',
    ],
    tourismType: 'Cultural and Historical Attractions',
    category: 'museum',
    cityName: 'Cairo',
    rate: 4.6,
    totalRates: 8700,
    description:
        'The Museum of Egyptian Antiquities in Tahrir Square houses an extensive collection '
        'of ancient Egyptian artifacts, including the treasures of Tutankhamun\'s tomb.',
    googleMapsLink: 'https://maps.google.com/?q=Egyptian+Museum+Cairo',
  ),
  PlaceModel(
    id: '3',
    name: 'Khan El Khalili',
    profileImage: '$_img/khanelkhalili/400/300',
    carouselImages: [
      '$_img/khanelkhalili1/400/300',
      '$_img/khanelkhalili2/400/300',
    ],
    tourismType: 'Entertainment and Modern Attractions',
    category: 'shopping',
    cityName: 'Cairo',
    rate: 4.3,
    totalRates: 5600,
    description:
        'Khan El Khalili is a famous bazaar and souk in historic Cairo. '
        'Established in 1382, it offers a mix of traditional crafts, jewelry, spices, '
        'and souvenirs in its winding alleyways.',
    googleMapsLink: 'https://maps.google.com/?q=Khan+El+Khalili',
  ),
  PlaceModel(
    id: '4',
    name: 'Mount Sinai',
    profileImage: '$_img/mountsinai/400/300',
    carouselImages: [
      '$_img/mountsinai1/400/300',
      '$_img/mountsinai2/400/300',
    ],
    tourismType: 'Religious and Spiritual Attractions',
    category: 'historical site',
    cityName: 'South Sinai',
    rate: 4.7,
    totalRates: 4200,
    description:
        'Mount Sinai is a sacred mountain where Moses is said to have received the Ten Commandments. '
        'A popular pilgrimage site, it offers breathtaking sunrise views from the summit.',
    googleMapsLink: 'https://maps.google.com/?q=Mount+Sinai',
  ),
  PlaceModel(
    id: '5',
    name: 'Sharm El-Sheikh Beaches',
    profileImage: '$_img/sharm/400/300',
    carouselImages: [
      '$_img/sharm1/400/300',
      '$_img/sharm2/400/300',
    ],
    tourismType: 'Natural Attractions',
    category: 'historical site',
    cityName: 'Sharm El-Sheikh',
    rate: 4.8,
    totalRates: 9800,
    description:
        'Sharm El-Sheikh is a world-renowned resort town on the Red Sea coast. '
        'Famous for its crystal-clear waters, coral reefs, and vibrant marine life, '
        'it is a paradise for snorkelers and divers.',
    googleMapsLink: 'https://maps.google.com/?q=Sharm+El+Sheikh',
  ),
  PlaceModel(
    id: '6',
    name: 'Valley of the Kings',
    profileImage: '$_img/valleykings/400/300',
    carouselImages: [
      '$_img/valleykings1/400/300',
      '$_img/valleykings2/400/300',
    ],
    tourismType: 'Cultural and Historical Attractions',
    category: 'historical site',
    cityName: 'Luxor',
    rate: 4.8,
    totalRates: 7200,
    description:
        'The Valley of the Kings is a burial site for pharaohs of the New Kingdom, '
        'including the famous tomb of Tutankhamun. Located on the west bank of the Nile in Luxor.',
    googleMapsLink: 'https://maps.google.com/?q=Valley+of+the+Kings',
  ),
  PlaceModel(
    id: '7',
    name: 'Abu Simbel Temples',
    profileImage: '$_img/abusimbel/400/300',
    carouselImages: [
      '$_img/abusimbel1/400/300',
      '$_img/abusimbel2/400/300',
    ],
    tourismType: 'Cultural and Historical Attractions',
    category: 'temple',
    cityName: 'Aswan',
    rate: 4.9,
    totalRates: 6400,
    description:
        'The Abu Simbel temples are two massive rock-cut temples built by Ramesses II. '
        'They were relocated in a remarkable UNESCO operation to save them from flooding.',
    googleMapsLink: 'https://maps.google.com/?q=Abu+Simbel',
  ),
  PlaceModel(
    id: '8',
    name: 'Al-Azhar Mosque',
    profileImage: '$_img/alazhar/400/300',
    carouselImages: [
      '$_img/alazhar1/400/300',
      '$_img/alazhar2/400/300',
    ],
    tourismType: 'Religious and Spiritual Attractions',
    category: 'mosque',
    cityName: 'Cairo',
    rate: 4.5,
    totalRates: 3800,
    description:
        'Al-Azhar Mosque is one of Cairo\'s oldest mosques, founded in 970 AD. '
        'It is also the center of Al-Azhar University, one of the world\'s oldest universities.',
    googleMapsLink: 'https://maps.google.com/?q=Al+Azhar+Mosque',
  ),
  PlaceModel(
    id: '9',
    name: 'White Desert',
    profileImage: '$_img/whitedesert/400/300',
    carouselImages: [
      '$_img/whitedesert1/400/300',
      '$_img/whitedesert2/400/300',
    ],
    tourismType: 'Natural Attractions',
    category: 'historical site',
    cityName: 'New Valley',
    rate: 4.6,
    totalRates: 2900,
    description:
        'The White Desert in Egypt features stunning chalk rock formations created by sandstorms. '
        'The surreal landscape looks like a snow-covered wonderland in the middle of the desert.',
    googleMapsLink: 'https://maps.google.com/?q=White+Desert+Egypt',
  ),
  PlaceModel(
    id: '10',
    name: 'Citadel of Saladin',
    profileImage: '$_img/citadel/400/300',
    carouselImages: [
      '$_img/citadel1/400/300',
      '$_img/citadel2/400/300',
    ],
    tourismType: 'Cultural and Historical Attractions',
    category: 'fortress',
    cityName: 'Cairo',
    rate: 4.4,
    totalRates: 5100,
    description:
        'The Citadel of Saladin is a medieval Islamic fortification in Cairo. '
        'It offers panoramic views of the city and houses several museums and mosques.',
    googleMapsLink: 'https://maps.google.com/?q=Citadel+of+Saladin',
  ),
  PlaceModel(
    id: '11',
    name: 'Hurghada Marina',
    profileImage: '$_img/hurghada/400/300',
    carouselImages: [
      '$_img/hurghada1/400/300',
      '$_img/hurghada2/400/300',
    ],
    tourismType: 'Entertainment and Modern Attractions',
    category: 'shopping',
    cityName: 'Hurghada',
    rate: 4.3,
    totalRates: 4500,
    description:
        'Hurghada Marina is a modern waterfront destination with restaurants, cafes, '
        'shops, and nightlife. It\'s the perfect spot for a relaxing evening by the Red Sea.',
    googleMapsLink: 'https://maps.google.com/?q=Hurghada+Marina',
  ),
  PlaceModel(
    id: '12',
    name: 'Alexandria Library',
    profileImage: '$_img/alexlibrary/400/300',
    carouselImages: [
      '$_img/alexlibrary1/400/300',
      '$_img/alexlibrary2/400/300',
    ],
    tourismType: 'Cultural and Historical Attractions',
    category: 'library',
    cityName: 'Alexandria',
    rate: 4.5,
    totalRates: 6100,
    description:
        'The Bibliotheca Alexandrina is a modern revival of the ancient Library of Alexandria. '
        'It serves as a cultural center with museums, galleries, and a vast reading hall.',
    googleMapsLink: 'https://maps.google.com/?q=Bibliotheca+Alexandrina',
  ),
  PlaceModel(
    id: '13',
    name: 'St. Catherine Monastery',
    profileImage: '$_img/stcatherine/400/300',
    carouselImages: [
      '$_img/stcatherine1/400/300',
      '$_img/stcatherine2/400/300',
    ],
    tourismType: 'Religious and Spiritual Attractions',
    category: 'historical site',
    cityName: 'South Sinai',
    rate: 4.7,
    totalRates: 3300,
    description:
        'St. Catherine\'s Monastery is one of the oldest working Christian monasteries in the world. '
        'Located at the foot of Mount Sinai, it is a UNESCO World Heritage site.',
    googleMapsLink: 'https://maps.google.com/?q=St+Catherine+Monastery',
  ),
  PlaceModel(
    id: '14',
    name: 'Siwa Oasis',
    profileImage: '$_img/siwa/400/300',
    carouselImages: [
      '$_img/siwa1/400/300',
      '$_img/siwa2/400/300',
    ],
    tourismType: 'Natural Attractions',
    category: 'historical site',
    cityName: 'Siwah',
    rate: 4.4,
    totalRates: 2100,
    description:
        'Siwa Oasis is a remote desert oasis known for its natural springs, ancient ruins, '
        'and unique Berber culture. The Shali Fortress and Cleopatra\'s Bath are must-sees.',
    googleMapsLink: 'https://maps.google.com/?q=Siwa+Oasis',
  ),
  PlaceModel(
    id: '15',
    name: 'Dahab Lagoon',
    profileImage: '$_img/dahab/400/300',
    carouselImages: [
      '$_img/dahab1/400/300',
      '$_img/dahab2/400/300',
    ],
    tourismType: 'Natural Attractions',
    category: 'historical site',
    cityName: 'Dahab',
    rate: 4.5,
    totalRates: 3600,
    description:
        'Dahab is a laid-back beach town on the Red Sea coast, famous for windsurfing, '
        'kitesurfing, and the Blue Hole diving site. It\'s a favorite among backpackers.',
    googleMapsLink: 'https://maps.google.com/?q=Dahab+Egypt',
  ),
  PlaceModel(
    id: '16',
    name: 'Luxor Temple',
    profileImage: '$_img/luxtemple/400/300',
    carouselImages: [
      '$_img/luxtemple1/400/300',
      '$_img/luxtemple2/400/300',
    ],
    tourismType: 'Cultural and Historical Attractions',
    category: 'temple',
    cityName: 'Luxor',
    rate: 4.7,
    totalRates: 5900,
    description:
        'Luxor Temple is a stunning ancient Egyptian temple complex on the east bank of the Nile. '
        'It was the center of the Opet Festival and is beautifully illuminated at night.',
    googleMapsLink: 'https://maps.google.com/?q=Luxor+Temple',
  ),
];

// ============ Mock Events ============

final List<Map<String, dynamic>> mockEvents = [
  {
    'event_id': '1',
    'event_name': 'Cairo International Film Festival',
    'Image': '$_img/filmfestival/400/300',
    'event_date': '15 Dec 2026',
    'event_type': 'Cultural',
    'city_name': 'Cairo',
    'event_time': '7:00 PM',
    'ticket_price': '200',
    'registration_link': 'https://example.com/filmfest',
  },
  {
    'event_id': '2',
    'event_name': 'Sharm El-Sheikh Jazz Festival',
    'Image': '$_img/jazzfest/400/300',
    'event_date': '20-22 Jan 2027',
    'event_type': 'Music',
    'city_name': 'Sharm El-Sheikh',
    'event_time': '6:00 PM',
    'ticket_price': '350',
    'registration_link': 'https://example.com/jazzfest',
  },
  {
    'event_id': '3',
    'event_name': 'Luxor Heritage Festival',
    'Image': '$_img/heritagefest/400/300',
    'event_date': '10 Feb 2027',
    'event_type': 'Cultural',
    'city_name': 'Luxor',
    'event_time': '9:00 AM',
    'ticket_price': '150',
    'registration_link': 'https://example.com/heritage',
  },
  {
    'event_id': '4',
    'event_name': 'Alexandria Book Fair',
    'Image': '$_img/bookfair/400/300',
    'event_date': '25 Mar 2027',
    'event_type': 'Educational',
    'city_name': 'Alexandria',
    'event_time': '10:00 AM',
    'ticket_price': 'Free',
    'registration_link': 'https://example.com/bookfair',
  },
  {
    'event_id': '5',
    'event_name': 'Hurghada Food Festival',
    'Image': '$_img/foodfest/400/300',
    'event_date': '5 Apr 2027',
    'event_type': 'Food',
    'city_name': 'Hurghada',
    'event_time': '12:00 PM',
    'ticket_price': '250',
    'registration_link': 'https://example.com/foodfest',
  },
];

// ============ Mock Activities ============

final List<Map<String, dynamic>> mockActivities = [
  {
    'id': '1',
    'title': 'Red Sea Snorkeling Adventure',
    'Image': '$_img/snorkeling/400/300',
    'activity_type': 'Diving',
    'city_name': 'Hurghada',
    'price_before': '1500',
    'price_after': '900',
    'rating': '4.8',
    'link': 'https://example.com/snorkel',
  },
  {
    'id': '2',
    'title': 'Hot Air Balloon over Luxor',
    'Image': '$_img/balloon/400/300',
    'activity_type': 'Balloon Tours',
    'city_name': 'Luxor',
    'price_before': '3000',
    'price_after': '2200',
    'rating': '4.9',
    'link': 'https://example.com/balloon',
  },
  {
    'id': '3',
    'title': 'Camel Ride at the Pyramids',
    'Image': '$_img/camelride/400/300',
    'activity_type': 'Camel Tours',
    'city_name': 'Giza',
    'price_before': '800',
    'price_after': '500',
    'rating': '4.5',
    'link': 'https://example.com/camel',
  },
  {
    'id': '4',
    'title': 'Safari in the White Desert',
    'Image': '$_img/safari/400/300',
    'activity_type': 'Safari',
    'city_name': 'New Valley',
    'price_before': '2500',
    'price_after': '1800',
    'rating': '4.7',
    'link': 'https://example.com/safari',
  },
  {
    'id': '5',
    'title': 'Swimming with Dolphins in Sharm',
    'Image': '$_img/dolphins/400/300',
    'activity_type': 'Swimming With Dolphins',
    'city_name': 'Sharm El-Sheikh',
    'price_before': '2000',
    'price_after': '1200',
    'rating': '4.6',
    'link': 'https://example.com/dolphins',
  },
  {
    'id': '6',
    'title': 'Submarine Tour in Hurghada',
    'Image': '$_img/submarine/400/300',
    'activity_type': 'Submarine Tours',
    'city_name': 'Hurghada',
    'price_before': '1800',
    'price_after': '1400',
    'rating': '4.4',
    'link': 'https://example.com/submarine',
  },
];

// ============ Mock User ============

final EgyptopiaUser mockUser = EgyptopiaUser(
  id: 'mock-user-001',
  name: 'Ahmed Hassan',
  email: 'ahmed@example.com',
  country: 'Egypt',
  dateOfBirth: '1998-05-15',
  gender: 'male',
  profileImg: null,
  preferredCategories: ['museum', 'historical site', 'temple'],
  preferredTourismTypes: [
    'Cultural and Historical Attractions',
    'Natural Attractions',
  ],
  preferredCities: ['Cairo', 'Luxor', 'Aswan'],
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
