import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  Preferences._() {
    init();
  }

  static SharedPreferences? _prefs; // = await SharedPreferences.getInstance();

  static Future<SharedPreferences> get preferences async {
    if (_prefs != null) return _prefs!;
    return _prefs = await SharedPreferences.getInstance();
  }

  init() async {
    String? downloadLocation = (await getDownloadsDirectory())?.path;
    if (downloadLocation != null) setDownloadLocation(downloadLocation);
  }

  static Future<String?> get downloadLocation async =>
      (await preferences).getString("download_location");

  static setDownloadLocation(String value) async =>
      (await preferences).getString("download_location");
}
