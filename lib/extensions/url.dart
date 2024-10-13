String? fileNameFromContentDiscriptionHeader(String? value) {
  if (value == null) return null;
  // Split the string on "filename="
  final parts = value.split('filename=');

  if (parts.length < 2) return null; // No filename found

  // Take the second part, which should contain the filename and possibly more
  var fileNamePart =
      parts[1].split(';')[0]; // Split by semicolon and take the first part

  // Remove surrounding quotes and trim whitespace
  var fileName = fileNamePart.replaceAll('"', '').trim();
  return fileName.isNotEmpty ? fileName : null;
}

String? fileNameFromContentTypeHeader(String? value) {
  return value?.replaceFirst('/', '.');
}

String _fromUrl(String url) {
  Uri uri = Uri.parse(url);
  return uri.pathSegments.isNotEmpty ? uri.pathSegments.last : '';
}

String fileName(Uri url, Map<String, String> headers) {
  String fileName = '';

  // Check Content-Disposition header first
  if (headers.containsKey('Content-Disposition')) {
    final contentDisposition = headers['Content-Disposition']!;
    final filenameMatch =
        RegExp(r'filename="([^"]+)"').firstMatch(contentDisposition);
    if (filenameMatch != null) {
      fileName = filenameMatch.group(1)!.trim();
    }
  }

  // If no filename from Content-Disposition, use URL path
  if (fileName.isEmpty) {
    fileName = url.pathSegments.last;
  }

  // Sanitize the filename to avoid potential security risks
  fileName = sanitizeFilename(fileName);

  // Add a default extension if missing based on Content-Type
  if (!fileName.contains('.')) {
    final contentType = headers['Content-Type'] ?? 'application/octet-stream';
    final extension = getExtensionFromContentType(contentType);
    if (extension != null) {
      fileName += extension;
    }
  }

  return fileName;
}

String sanitizeFilename(String filename) {
  // Remove invalid characters and replace spaces with underscores
  return filename.replaceAll(RegExp(r'[<>:"/\\|?*\]]'), '_');
}

String? getExtensionFromContentType(String contentType) {
  // Map common content types to their corresponding extensions
  final contentTypeMap = {
    'image/jpeg': '.jpg',
    'image/png': '.png',
    'image/gif': '.gif',
    'application/pdf': '.pdf',
    'text/plain': '.txt',
    'application/zip': '.zip',
    // Add more mappings as needed
  };

  return contentTypeMap[contentType];
}
