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
