import 'package:frontend_flutter/api/models/responses/base_response.dart';

class GetPredictionResponse extends BaseApiResponse {
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

  GetPredictionResponse.fromJson(super.json)
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
}
