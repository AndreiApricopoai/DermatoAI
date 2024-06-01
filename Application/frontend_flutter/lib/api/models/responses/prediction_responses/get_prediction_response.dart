import 'package:frontend_flutter/api/models/responses/base_response.dart';
import 'package:frontend_flutter/api/models/responses/prediction_responses/prediction_response.dart';
import 'package:intl/intl.dart';

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
  final String? createdAt;

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
        createdAt = formatDate(json['data']?['createdAt']),
        super.fromJson();

  Prediction toPrediction() {
    return Prediction(
        predictionId: predictionId,
        userId: userId,
        title: title,
        description: description,
        imageUrl: imageUrl,
        isHealthy: isHealthy,
        diagnosisName: diagnosisName,
        diagnosisCode: diagnosisCode,
        diagnosisType: diagnosisType,
        confidenceLevel: confidenceLevel,
        status: status,
        createdAt: createdAt);
  }

  static String? formatDate(String? isoDate) {
    if (isoDate == null) return null;
    DateTime date = DateTime.parse(isoDate);
    return DateFormat('dd-MM-yyyy').format(date);
  }
}
