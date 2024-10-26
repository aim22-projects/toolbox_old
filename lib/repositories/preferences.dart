import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toolbox/constants/preferences_keys.dart';

class Preferences {
  Preferences._() {
    init();
  }
  static SharedPreferencesAsync preferences = SharedPreferencesAsync();

  init() async {
    var downloadLocation = (await getDownloadsDirectory())?.path;
    if (downloadLocation != null) setDownloadLocation(downloadLocation);
  }

  static Future<String?> get downloadLocation =>
      preferences.getString(PreferencesKeys.downloadLocation);

  static Future<String?> get themeMode =>
      preferences.getString(PreferencesKeys.themeMode);

  static setDownloadLocation(String value) =>
      preferences.setString(PreferencesKeys.downloadLocation, value);

  static setThemeMode(String value) =>
      preferences.setString(PreferencesKeys.themeMode, value);
}
