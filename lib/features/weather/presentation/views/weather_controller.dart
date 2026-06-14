import 'dart:async';
import 'package:etrip/core/utils/size_config.dart';
import 'package:etrip/features/weather/data/weather_api.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:etrip/core/localization/translations.dart' as etrip;

class WeatherController extends GetxController {
  String lang = 'en';

  /// Convert app language code ('zh') to OpenWeatherMap code ('zh_cn')
  String get _apiLang => lang == 'zh' ? 'zh_cn' : 'en';

  /// Map English city names to Chinese (OpenWeatherMap always returns English names)
  static const _cityNamesZh = {
    'Chengdu': '成都',
    'Shuangliu': '双流',
    'Shuangguisi': '双流',
    'Beijing': '北京',
    'Shanghai': '上海',
    'Guangzhou': '广州',
    'Shenzhen': '深圳',
    'Chongqing': '重庆',
    'Wuhan': '武汉',
    'Xi\'an': '西安',
    'Hangzhou': '杭州',
    'Kunming': '昆明',
    'Lhasa': '拉萨',
    'Guilin': '桂林',
    'Nanjing': '南京',
    'Changsha': '长沙',
    'Leshan': '乐山',
    'Mianyang': '绵阳',
    'Zigong': '自贡',
    'Ya\'an': '雅安',
    'Guanghan': '广汉',
    'Dujiangyan': '都江堰',
    'Pengzhou': '彭州',
    'Qionglai': '邛崃',
    'Chongzhou': '崇州',
    'Jintang': '金堂',
    'Pixian': '郫县',
    'Xindu': '新都',
    'Wenjiang': '温江',
    'Jiuzhaigou': '九寨沟',
    'Emeishan': '峨眉山',
    'Kangding': '康定',
    'Sichuan': '四川',
  };

  static const _countryNamesZh = {
    'CN': '中国',
  };


  RxString country = "".obs;
  RxInt weatherId = 0.obs;
  RxString city = "".obs;
  RxDouble temperature = 0.0.obs;
  RxString description = "".obs;
  RxString icon = "01d".obs;
  RxInt humidity = 0.obs;
  RxDouble windSpeed = 0.0.obs;
  RxInt pressure = 0.obs;
  RxBool isLoading = true.obs;
  bool initialized = false;
  RxString sunrise = "".obs;
  RxString sunset = "".obs;
  RxString dayOfWeek = "".obs;
  RxString currentTime = "".obs;
  RxList<Map<String, dynamic>> forecastData = <Map<String, dynamic>>[].obs;
  RxString errorMessage = "".obs;

  final WeatherApi _weatherApi = WeatherApi();

  RxBool isSearching = false.obs;

  final List<String> governoratesAndCities = [
    "Cairo",
    "Giza",
    "Alexandria",
    "Luxor",
    "Aswan",
    "Suez",
    "Ismailia",
    "Port Said",
    "Damietta",
    "Beheira",
    "Faiyum",
    "Beni Suef",
    "Minya",
    "Sohag",
    "Qena",
    "Red Sea",
    "New Valley",
    "South Sinai",
    "Sharm El-Sheikh",
    "Hurghada",
    "El Gouna",
    "Marsa Alam",
    "Nuweiba",
    "Safaga",
    "Al Arish",
    "Marsa Matruh",
    "Siwah",
    "Dahab",
    "Kafr Ash Shaykh",
    "Ain Sukhna"
  ].obs;

  RxList<String> filteredCities = <String>[].obs;

  void filterCities(String query) {
    if (query.isEmpty) {
      filteredCities.clear();
    } else {
      filteredCities.value = governoratesAndCities
          .where((city) => city.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Do not fetch here — let the screen set lang first via postFrameCallback
  }

  Future<void> getWeatherByLocation() async {
    try {
      double? lat;
      double? lon;

      // Try last known position first (fast)
      try {
        final lastPos = await Geolocator.getLastKnownPosition()
            .timeout(const Duration(seconds: 3));
        if (lastPos != null) {
          lat = lastPos.latitude;
          lon = lastPos.longitude;
        }
      } catch (_) {}

      // If last known failed, try current position
      if (lat == null) {
        try {
          LocationPermission permission = await Geolocator.checkPermission()
              .timeout(const Duration(seconds: 5));
          if (permission == LocationPermission.denied) {
            permission = await Geolocator.requestPermission()
                .timeout(const Duration(seconds: 5));
          }
          if (permission == LocationPermission.whileInUse ||
              permission == LocationPermission.always) {
            Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high,
            ).timeout(const Duration(seconds: 10));
            lat = position.latitude;
            lon = position.longitude;
          }
        } catch (_) {}
      }

      // Fallback to 四川大学江安校区 coordinates if no location obtained
      if (lat == null || lon == null) {
        lat = 30.5505;
        lon = 103.9985;
      }

      await fetchWeatherDataByCoordinates(lat, lon);
      errorMessage.value = '';
    } catch (e) {
      city.value = etrip.Translations.tr('location_error', lang);
      isLoading.value = false;
      errorMessage.value = e.toString();
    }
  }

  Future<void> fetchWeatherDataByCoordinates(double lat, double lon) async {
    var weatherData = await _weatherApi.getWeatherByLocation(lat, lon, lang: _apiLang);
    updateWeatherState(weatherData);

    var forecast = await _weatherApi.getWeatherForecast(lat, lon, lang: _apiLang);
    forecastData.assignAll(forecast);
  }

  Future<void> fetchWeatherDataByCity(String cityName) async {
    isLoading.value = true;
    var weatherData = await _weatherApi.getWeatherByCity(cityName, lang: _apiLang);
    if (weatherData.containsKey("error")) {
      city.value = weatherData["error"];
      isLoading.value = false;
    } else {
      updateWeatherState(weatherData);
    }

    var forecast = await _weatherApi.getWeatherForecastByCity(cityName, lang: _apiLang);
    forecastData.assignAll(forecast);
  }

  void updateWeatherState(Map<String, dynamic> weatherData) {
    if (weatherData.containsKey('error')) {
      throw Exception(weatherData['error']);
    }
    country.value = lang == 'zh' ? (_countryNamesZh[weatherData['country']] ?? weatherData['country'] ?? '') : (weatherData['country'] ?? '');
    weatherId.value = weatherData['id'] ?? 0;
    final rawCity = weatherData['city'] ?? '';
    city.value = lang == 'zh' ? (_cityNamesZh[rawCity] ?? rawCity) : rawCity;
    temperature.value = (weatherData['temperature'] ?? 0.0).toDouble();
    description.value = weatherData['description'] ?? '';
    icon.value = weatherData['icon'] ?? '01d';
    humidity.value = weatherData['humidity'] ?? 0;
    windSpeed.value = (weatherData['windSpeed'] ?? 0.0).toDouble();
    pressure.value = weatherData['pressure'] ?? 0;
    sunrise.value = weatherData['sunrise'] ?? '';
    sunset.value = weatherData['sunset'] ?? '';
    dayOfWeek.value = weatherData['dayOfWeek'] ?? '';
    currentTime.value = DateFormat('hh:mm a').format(DateTime.now());
    isLoading.value = false;
  }

  String getWeatherBackground() {
    if (weatherId >= 200 && weatherId < 300 || description.contains("storm")) {
      return "assets/images/storm.jpg";
    }
    if (weatherId >= 300 && weatherId < 600) {
      return "assets/images/rainy.jpg";
    }
    if (weatherId >= 600 && weatherId < 700 || temperature.value <= 2) {
      return "assets/images/snowy.jpg";
    }
    // ignore: unrelated_type_equality_checks
    if (weatherId == 800) {
      return "assets/images/sunny.jpg";
    }
    if (weatherId > 800) {
      return "assets/images/cloudy.jpg";
    }
    return "assets/images/weather_bg.jpg";
  }

  Widget getWeatherIcon() {
    if (icon.contains("01")) {
      return Image.asset("assets/images/sun.png",
          width: SizeConfig.defaultSize! * 7);
    }
    return Image.network(
      "https://openweathermap.org/img/wn/$icon@2x.png",
      width: SizeConfig.defaultSize! * 7,
      errorBuilder: (context, error, stackTrace) {
        return Icon(Icons.error,
            size: SizeConfig.defaultSize! * 7, color: Colors.red);
      },
    );
  }
}
