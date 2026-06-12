import 'dart:convert';

import 'package:etrip/core/config.dart';
import 'package:etrip/core/mock_data.dart';
import 'package:etrip/features/auth/data/egyptopia_api_service.dart';
import 'package:etrip/features/auth/data/services/local_storage_service.dart';
import 'package:etrip/features/weather/data/weather_api.dart';
import 'package:etrip/features/wishlist/data/service/favorite_service.dart';
import 'package:http/http.dart' as http;

class DeepSeekApiService {
  static const String _model = 'deepseek-chat';
  static final Uri _endpoint =
      Uri.parse('${AppConfig.deepseekBaseUrl}/chat/completions');

  final WeatherApi _weatherApi = WeatherApi();

  static const List<Map<String, dynamic>> _tools = [
    {
      'type': 'function',
      'function': {
        'name': 'get_weather',
        'description':
            'Get the current real-time weather of a city in China. ONLY call this when the user explicitly asks about the weather. Never bring up weather on your own.',
        'parameters': {
          'type': 'object',
          'properties': {
            'city': {
              'type': 'string',
              'description':
                  'City name in English, e.g. Beijing, Shanghai, Chengdu',
            },
          },
          'required': ['city'],
        },
      },
    },
  ];

  /// [history] uses the chat page format: {'role': 'user'|'bot', 'text': ...}.
  Future<String> chat(List<Map<String, String>> history, String lang) async {
    final messages = <Map<String, dynamic>>[
      {'role': 'system', 'content': await _buildSystemPrompt(lang)},
      for (final m in history)
        {
          'role': m['role'] == 'user' ? 'user' : 'assistant',
          'content': m['text'] ?? '',
        },
    ];

    // Allow at most two tool rounds before forcing a plain answer.
    for (var round = 0; round < 3; round++) {
      final message = await _complete(messages, withTools: round < 2);
      final toolCalls = message['tool_calls'] as List?;

      if (toolCalls == null || toolCalls.isEmpty) {
        return (message['content'] as String?)?.trim() ?? '';
      }

      messages.add(message);
      for (final call in toolCalls) {
        messages.add({
          'role': 'tool',
          'tool_call_id': call['id'],
          'content': await _executeTool(call, lang),
        });
      }
    }
    throw Exception('DeepSeek: too many tool rounds');
  }

  Future<Map<String, dynamic>> _complete(
    List<Map<String, dynamic>> messages, {
    required bool withTools,
  }) async {
    final response = await http
        .post(
          _endpoint,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${AppConfig.deepseekApiKey}',
          },
          body: jsonEncode({
            'model': _model,
            'messages': messages,
            'max_tokens': 600,
            if (withTools) 'tools': _tools,
          }),
        )
        .timeout(const Duration(seconds: 45));

    if (response.statusCode != 200) {
      throw Exception('DeepSeek API error ${response.statusCode}');
    }

    final data = jsonDecode(utf8.decode(response.bodyBytes));
    return Map<String, dynamic>.from(data['choices'][0]['message']);
  }

  Future<String> _executeTool(Map<String, dynamic> call, String lang) async {
    final function = call['function'] ?? {};
    if (function['name'] != 'get_weather') {
      return jsonEncode({'error': 'unknown tool'});
    }
    try {
      final args = jsonDecode(function['arguments'] ?? '{}');
      final city = (args['city'] ?? '').toString();
      final weather = await _weatherApi.getWeatherByCity(
        city,
        lang: lang == 'zh' ? 'zh_cn' : 'en',
      );
      if (weather.containsKey('error')) {
        return jsonEncode({'error': weather['error']});
      }
      return jsonEncode({
        'city': weather['city'],
        'temperature_c': weather['temperature'],
        'feels_like_c': weather['feelsLike'],
        'description': weather['description'],
        'humidity_percent': weather['humidity'],
        'wind_speed_ms': weather['windSpeed'],
      });
    } catch (e) {
      return jsonEncode({'error': 'failed to fetch weather'});
    }
  }

  Future<String> _buildSystemPrompt(String lang) async {
    final isZh = lang == 'zh';
    final buffer = StringBuffer();

    buffer.writeln(isZh
        ? '你是 Etrip 旅行 App 的智能旅行助手，专注中国旅游。请始终用中文回答，语气友好，回答简洁（不超过200字），多用具体建议。'
        : 'You are the AI travel assistant of the Etrip travel app, specialized in travel in China. Always answer in English, in a friendly tone, concisely (under 150 words), with concrete suggestions.');

    final placeList = mockPlaces.map((p) {
      final name = isZh ? (placeNamesZh[p.id] ?? p.name) : p.name;
      final city = isZh ? (cityNamesZh[p.cityName] ?? p.cityName) : p.cityName;
      return '$name($city)';
    }).join(', ');
    buffer.writeln(isZh
        ? '本 App 收录的景点有：$placeList。推荐景点时请优先推荐这些。'
        : 'Places featured in this app: $placeList. Prefer recommending these when suggesting places.');

    final favorites = _favoritesLine(isZh);
    if (favorites != null) buffer.writeln(favorites);

    final preferences = await _preferencesLine(isZh);
    if (preferences != null) buffer.writeln(preferences);

    return buffer.toString();
  }

  String? _favoritesLine(bool isZh) {
    try {
      final favorites = FavoriteService.getAllFavorites();
      if (favorites.isEmpty) return null;
      final items = favorites.map((f) {
        final name = isZh ? (placeNamesZh[f.id] ?? f.title) : f.title;
        final city = isZh ? (cityNamesZh[f.city] ?? f.city) : f.city;
        return '$name($city)';
      }).join(', ');
      return isZh
          ? '用户在 App 中收藏了：$items。当用户要求个性化推荐时，请参考这些收藏。'
          : 'The user has favorited in the app: $items. Use these when asked for personalized recommendations.';
    } catch (_) {
      return null;
    }
  }

  Future<String?> _preferencesLine(bool isZh) async {
    try {
      final uid = LocalStorageService().currentUid;
      if (uid == null || uid.isEmpty) return null;
      final prefs = await EgyptopiaApiService()
          .getUserPreferences(uid)
          .timeout(const Duration(seconds: 2));
      if (prefs == null) return null;
      final categories = List<String>.from(prefs['category'] ?? []);
      final cities = List<String>.from(prefs['city'] ?? []);
      if (categories.isEmpty && cities.isEmpty) return null;
      return isZh
          ? '用户的旅行偏好：类型 ${categories.join('、')}；城市 ${cities.join('、')}。'
          : 'User travel preferences: categories ${categories.join(', ')}; cities ${cities.join(', ')}.';
    } catch (_) {
      return null;
    }
  }
}
