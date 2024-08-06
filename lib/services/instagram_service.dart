import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:toolbox/models/instagram_reel.dart';

class InstagramService {
  InstagramService._internal();

  static InstagramService get _instance => InstagramService._internal();

  factory InstagramService() => _instance;

  Future<InstagramReel?> fetchReelInfo(String reelID) async {
    var url = Uri.https('www.instagram.com', 'graphql/query', {
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

    print(response.body);

    // 4. return null if invalid response
    if (responseJson['data']['shortcode_media'] == null) {
      return null;
    }

    // 5. return null if invalid response
    if (!responseJson['data']['shortcode_media']['is_video']) {
      return null;
    }

    // 5. parse data from json
    // String videoLink = responseJson['data']['shortcode_media']['video_url'];
    // String videoThumbnail =
    //     responseJson['data']['shortcode_media']['thumbnail_src'];

    // 6. return reel data
    return InstagramReel.from(responseJson);
  }
}
