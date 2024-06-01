import 'dart:convert';

class PatchPredictionRequest {
  final String predictionId;
  final String? title;
  final String? description;

  PatchPredictionRequest({
    required this.predictionId,
    this.title,
    this.description,
  });

  String toJson() {
    final Map<String, dynamic> data = {};
    if (title != null) data['title'] = title;
    if (description != null) data['description'] = description;
    return json.encode(data);
    
  }

  String getUrl(String baseUrl) {
    return '$baseUrl/$predictionId';
  }
}
