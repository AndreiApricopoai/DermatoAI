import 'package:frontend_flutter/api/models/responses/base_response.dart';
import 'package:frontend_flutter/api/models/responses/prediction_responses/prediction_response.dart';
import 'package:intl/intl.dart';

class CreatePredictionResponse extends BaseApiResponse {
  final String? dataMessage;
  final String? predictionId;
  final String? userId;
  final String? title;
  final String? status;
  final String? imageUrl;
  final String? createdAt;

  Prediction toPrediction() {
    return Prediction(
        predictionId: predictionId,
        userId: userId,
        title: title,
        imageUrl: imageUrl,
        status: status,
        createdAt: createdAt);
  }

  CreatePredictionResponse.fromJson(super.json)
      : dataMessage = json['data']?['message'],
        predictionId = json['data']?['prediction']?['predictionId'],
        userId = json['data']?['prediction']?['userId'],
        title = json['data']?['prediction']?['title'],
        status = json['data']?['prediction']?['status'],
        imageUrl = json['data']?['prediction']?['imageUrl'],
        createdAt = formatDate(json['data']?['prediction']?['createdAt']),
        super.fromJson();

  static String? formatDate(String? isoDate) {
    if (isoDate == null) return null;
    DateTime date = DateTime.parse(isoDate);
    return DateFormat('dd-MM-yyyy').format(date);
  }
}
