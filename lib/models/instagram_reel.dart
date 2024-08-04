class InstagramReel {
  final String videoLink;
  final String videoThumbnail;

  const InstagramReel({required this.videoLink, required this.videoThumbnail});

  InstagramReel.from(Map<String, dynamic> value)
      : videoLink = value['data']['shortcode_media']['video_url'] ?? '',
        videoThumbnail =
            value['data']['shortcode_media']['thumbnail_src'] ?? '';
}
