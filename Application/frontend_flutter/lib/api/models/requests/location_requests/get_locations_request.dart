class GetLocationsRequest {
  final double latitude;
  final double longitude;
  final double radius;

  GetLocationsRequest({
    required this.latitude,
    required this.longitude,
    required this.radius,
  });

  Map<String, String> toQueryParameters() {
    return {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'radius': radius.toString(),
    };
  }
}