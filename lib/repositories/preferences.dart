import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  Preferences._() {
    init();
  }
  static SharedPreferencesAsync preferences = SharedPreferencesAsync();

  init() async {
    String? downloadLocation = (await getDownloadsDirectory())?.path;
    if (downloadLocation != null) setDownloadLocation(downloadLocation);
  }

  static Future<String?> get downloadLocation async =>
      preferences.getString("download_location");

  static setDownloadLocation(String value) async =>
      preferences.setString("download_location", value);

  static Future<String?> get themeMode async =>
      preferences.getString("theme_mode");

  static setThemeMode(String value) async =>
      preferences.setString("theme_mode", value);
}
