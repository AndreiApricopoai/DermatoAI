import 'package:frontend_flutter/api/models/responses/base_response.dart';

class CreatePredictionResponse extends BaseApiResponse {
  final String? dataMessage;
  final String? predictionId;
  final String? userId;
  final String? title;
  final String? status;
  final String? imageUrl;

  CreatePredictionResponse.fromJson(super.json)
      : dataMessage = json['data']?['message'],
        predictionId = json['data']?['prediction']?['predictionId'],
        userId = json['data']?['prediction']?['userId'],
        title = json['data']?['prediction']?['title'],
        status = json['data']?['prediction']?['status'],
        imageUrl = json['data']?['prediction']?['imageUrl'],
        super.fromJson();
}
