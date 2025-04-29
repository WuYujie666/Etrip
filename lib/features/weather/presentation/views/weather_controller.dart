import 'package:egyptopia/core/utils/size_config.dart';
import 'package:egyptopia/features/weather/data/weather_api.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class WeatherController extends GetxController {
  RxString country = "".obs;
  RxInt weatherId = 0.obs;
  RxString city = "Loading...".obs;
  RxDouble temperature = 0.0.obs;
  RxString description = "".obs;
  RxString icon = "01d".obs;
  RxInt humidity = 0.obs;
  RxDouble windSpeed = 0.0.obs;
  RxInt pressure = 0.obs;
  RxBool isLoading = true.obs;
  RxString sunrise = "".obs;
  RxString sunset = "".obs;
  RxString dayOfWeek = "".obs;
  RxString currentTime = "".obs;
  RxList<Map<String, dynamic>> forecastData = <Map<String, dynamic>>[].obs;

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
    getWeatherByLocation();
  }

  Future<void> getWeatherByLocation() async {
    try {
      Position? lastKnownPosition = await Geolocator.getLastKnownPosition();
      if (lastKnownPosition != null) {
        fetchWeatherDataByCoordinates(
            lastKnownPosition.latitude, lastKnownPosition.longitude);
      } else {
        city.value = "Locating...";
      }
      Position position = await _determinePosition();
      await fetchWeatherDataByCoordinates(
          position.latitude, position.longitude);
    } catch (e) {
      city.value = "Location Error";
      isLoading.value = false;
          rethrow; 

    }
  }

  Future<void> fetchWeatherDataByCoordinates(double lat, double lon) async {
    var weatherData = await _weatherApi.getWeatherByLocation(lat, lon);
    updateWeatherState(weatherData);

    var forecast = await _weatherApi.getWeatherForecast(lat, lon);
    forecastData.assignAll(forecast);
  }

  Future<void> fetchWeatherDataByCity(String cityName) async {
    isLoading.value = true;
    var weatherData = await _weatherApi.getWeatherByCity(cityName);
    if (weatherData.containsKey("error")) {
      city.value = weatherData["error"];
      isLoading.value = false;
    } else {
      updateWeatherState(weatherData);
    }

    var forecast = await _weatherApi.getWeatherForecastByCity(cityName);
    forecastData.assignAll(forecast);
  }

  void updateWeatherState(Map<String, dynamic> weatherData) {
    country.value = weatherData['country'];
    weatherId.value = weatherData['id'];
    city.value = weatherData['city'];
    temperature.value = weatherData['temperature'].toDouble();
    description.value = weatherData['description'];
    icon.value = weatherData['icon'];
    humidity.value = weatherData['humidity'];
    windSpeed.value = weatherData['windSpeed'].toDouble();
    pressure.value = weatherData['pressure'];
    sunrise.value = weatherData['sunrise'];
    sunset.value = weatherData['sunset'];
    dayOfWeek.value = weatherData['dayOfWeek'];
    currentTime.value = DateFormat('hh:mm a').format(DateTime.now());
    isLoading.value = false;
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception("Location services are disabled.");
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location permissions are denied.");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception("PERMISSION_DENIED_FOREVER");
    }

    return await Geolocator.getCurrentPosition();
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
