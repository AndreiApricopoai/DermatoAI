class PredictionResponse {
  final String? predictionId;
  final String? userId;
  final String? title;
  final String? description;
  final String? imageUrl;
  final bool? isHealthy;
  final String? diagnosisName;
  final int? diagnosisCode;
  final String? diagnosisType;
  final double? confidenceLevel;
  final String? status;

  PredictionResponse.fromJson(Map<String, dynamic> json)
      : predictionId = json['id'],
        userId = json['userId'],
        title = json['title'],
        description = json['description'],
        imageUrl = json['imageUrl'],
        isHealthy = json['isHealthy'],
        diagnosisName = json['diagnosisName'],
        diagnosisCode = json['diagnosisCode'],
        diagnosisType = json['diagnosisType'],
        confidenceLevel = json['confidenceLevel'],
        status = json['status'];
}
