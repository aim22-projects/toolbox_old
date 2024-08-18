import 'package:http/http.dart' as http;

class InternetRepository {
  Future<(String, String?, int?)?>? fileDetails(String url) async {
    Uri uri = Uri.parse(url);
    var response = await http.head(uri);

    // 4. check response status code
    if (response.statusCode != 200) return null;
    // 5. parse headers
    final int? fileSize =
        int.tryParse(response.headers['content-length'] ?? '');
    final String? fileType = response.headers['content-type'];
    final String fileName = response.headers['content-disposition'] ??
        (response.headers['content-type'] ?? '').replaceFirst('/', '.');

    return (fileName, fileType, fileSize);
  }
}
