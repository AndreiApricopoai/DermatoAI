import 'package:frontend_flutter/api/models/responses/base_response.dart';

class PredictionResponse extends BaseApiResponse {
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

  PredictionResponse.fromJson(super.json)
      : predictionId = json['data']?['id'],
        userId = json['data']?['userId'],
        title = json['data']?['title'],
        description = json['data']?['description'],
        imageUrl = json['data']?['imageUrl'],
        isHealthy = json['data']?['isHealthy'],
        diagnosisName = json['data']?['diagnosisName'],
        diagnosisCode = json['data']?['diagnosisCode'],
        diagnosisType = json['data']?['diagnosisType'],
        confidenceLevel = json['data']?['confidenceLevel'],
        status = json['data']?['status'],
        super.fromJson();

    PredictionResponse.fromJsonElement(super.json)
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
        status = json['status'],
        super.fromJson();
}
