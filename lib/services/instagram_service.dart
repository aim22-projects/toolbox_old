import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:toolbox/models/instagram_reel.dart';

class InstagramService {
  InstagramService._internal();

  // instragram reel link
  static bool isInstagramLink(String url) {
    return url.startsWith("https://www.instagram.com/reel/");
  }

  static Future<InstagramReel?> getReelInfoFromUrl(String url) async {
    if (!isInstagramLink(url)) return null;
    // 2. parse instagram reel data
    // example instagram reel url
    // "https://www.instagram.com/reel/C-RYWZCN2TY/?utm_source=ig_web_copy_link";
    String reelId = url.split("/reel/")[1].split("/")[0];

    return await fetchReelInfoFromReelId(reelId);
  }

  static Future<InstagramReel?> fetchReelInfoFromReelId(String reelID) async {
    var url = Uri.https('www.instagram.com', '/graphql/query', {
      'hl': 'en',
      'query_hash': 'b3055c01b4b222b8a47dc12b090e4e64',
      'variables': jsonEncode({
        "child_comment_count": 3,
        "fetch_comment_count": 40,
        "has_threaded_comments": true,
        "parent_comment_count": 24,
        "shortcode": reelID
      })
    });
    // 1. get reel data
    var response = await http.get(url);

    // 2. return null if invalid response
    if (response.statusCode != 200) return null;

    // 3. parse response
    var responseJson = jsonDecode(response.body) as Map<String, dynamic>;

    // 4. return null if invalid response
    if (responseJson['data']['shortcode_media'] == null) {
      return null;
    }

    // 5. return null if invalid response
    if (!responseJson['data']['shortcode_media']['is_video']) {
      return null;
    }

    // 6. return reel data
    return InstagramReel.from(responseJson);
  }
}
