class DeletePredictionRequest {
  final String predictionId;

  DeletePredictionRequest({
    required this.predictionId,
  });

  String getUrl(String baseUrl) {
    return '$baseUrl/$predictionId';
  }
}