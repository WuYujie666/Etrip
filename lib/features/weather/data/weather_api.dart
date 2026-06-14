import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WeatherApi {
  static const String apiKey = "2beb2a8911d5ee60a6cc73bfef4f3c2a";
  static const String baseUrl =
      "https://api.openweathermap.org/data/2.5/weather";
  static const String forecastUrl =
      "https://api.openweathermap.org/data/2.5/forecast";

  Future<Map<String, dynamic>> getWeatherByLocation(double lat, double lon,
      {String lang = "en"}) async {
    final Uri url = Uri.parse(
        "$baseUrl?lat=$lat&lon=$lon&appid=$apiKey&units=metric&lang=$lang");
    return await _fetchWeatherData(url);
  }

  Future<Map<String, dynamic>> getWeatherByCity(String city,
      {String lang = "en"}) async {
    if (city.trim().isEmpty) {
      return {"error": "❌ City name cannot be empty!"};
    }

    final Uri url =
        Uri.parse("$baseUrl?q=$city&appid=$apiKey&units=metric&lang=$lang");
    return await _fetchWeatherData(url);
  }

  Future<List<Map<String, dynamic>>> getWeatherForecast(double lat, double lon,
      {String lang = "en"}) async {
    final Uri url = Uri.parse(
        "$forecastUrl?lat=$lat&lon=$lon&appid=$apiKey&units=metric&lang=$lang");
    return await _fetchForecastData(url);
  }

  Future<List<Map<String, dynamic>>> getWeatherForecastByCity(String city,
      {String lang = "en"}) async {
    if (city.trim().isEmpty) {
      return [];
    }

    final Uri url =
        Uri.parse("$forecastUrl?q=$city&appid=$apiKey&units=metric&lang=$lang");
    return await _fetchForecastData(url);
  }

  /// 🔹 **دالة مساعدة** لجلب البيانات من API والتحقق من الأخطاء
  Future<Map<String, dynamic>> _fetchWeatherData(Uri url) async {
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // 🔹 تحويل التوقيت من Unix Timestamp إلى صيغة مقروءة
        final sunriseTime =
            DateTime.fromMillisecondsSinceEpoch(data["sys"]["sunrise"] * 1000)
                .toLocal();
        final sunsetTime =
            DateTime.fromMillisecondsSinceEpoch(data["sys"]["sunset"] * 1000)
                .toLocal();

        return {
          "country": data["sys"]["country"],
          "id": data["weather"][0]["id"],
          "city": data["name"],
          "temperature": data["main"]["temp"],
          "description": data["weather"][0]["description"],
          "icon": data["weather"][0]["icon"],
          "windSpeed": data["wind"]["speed"],
          "humidity": data["main"]["humidity"],
          "feelsLike": data["main"]["feels_like"],
          "pressure": data["main"]["pressure"],
          "sunrise": DateFormat('hh:mm a').format(sunriseTime),
          "sunset": DateFormat('hh:mm a').format(sunsetTime),
          "dayOfWeek": DateFormat('EEEE').format(DateTime.now()),
          "dateTime": DateTime.now().toString(),
        };
      } else if (response.statusCode == 404) {
        return {"error": "⚠️ City not found. Please check the spelling."};
      } else {
        return {
          "error":
              "⚠️ Unable to fetch weather (Status: ${response.statusCode})."
        };
      }
    } catch (e) {
      return {"error": "❌ Connection failed. Please check your internet."};
    }
  }

  Future<List<Map<String, dynamic>>> _fetchForecastData(Uri url) async {
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<Map<String, dynamic>> forecastList = [];

        for (var item in data['list']) {
          final dateTime =
              DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000).toLocal();
          forecastList.add({
            "dateTime": dateTime.toString(),
            "temperature": item['main']['temp'],
            "description": item['weather'][0]['description'],
            "icon": item['weather'][0]['icon'],
            "windSpeed": item['wind']['speed'],
            "humidity": item['main']['humidity'],
            "pressure": item['main']['pressure'],
          });
        }

        return forecastList;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
