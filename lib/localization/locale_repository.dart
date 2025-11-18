import 'package:shared_preferences/shared_preferences.dart';

class LocaleRepository {
  static const _key = 'selected_locale';

  Future<String?> loadLocale() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(_key); // không fallback ở đây
}

  Future<void> saveLocale(String locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, locale);
  }
}
