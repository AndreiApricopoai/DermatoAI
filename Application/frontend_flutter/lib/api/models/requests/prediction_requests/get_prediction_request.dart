class GetPredictionRequest {
  final String predictionId;

  GetPredictionRequest({
    required this.predictionId,
  });

  String getUrl(String baseUrl) {
    return '$baseUrl/$predictionId';
  }
}
