import 'package:hive/hive.dart';

/// Persists the latest chatbot conversation locally (same Hive pattern as
/// FavoriteService). Only one conversation is kept; "new chat" clears it.
class ChatHistoryService {
  static const String boxName = 'chat_history_box';
  static const String _key = 'messages';

  static Future<void> initHive() async {
    await Hive.openBox(boxName);
  }

  static Box get _box => Hive.box(boxName);

  static List<Map<String, String>> load() {
    final raw = _box.get(_key);
    if (raw is! List) return [];
    return [
      for (final item in raw)
        if (item is Map)
          {
            'role': item['role']?.toString() ?? 'bot',
            'text': item['text']?.toString() ?? '',
          },
    ];
  }

  static Future<void> save(List<Map<String, String>> messages) async {
    await _box.put(_key, messages);
  }

  static Future<void> clear() async {
    await _box.delete(_key);
  }
}
