class GetLocationImageRequest {
  final String photoReference;

  GetLocationImageRequest({
    required this.photoReference,
  });

  String getUrl(String baseUrl) {
    return '$baseUrl/$photoReference';
  }
}
