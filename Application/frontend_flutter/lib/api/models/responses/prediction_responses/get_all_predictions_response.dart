import 'package:frontend_flutter/api/models/responses/base_response.dart';
import 'package:frontend_flutter/api/models/responses/prediction_responses/prediction_response.dart';

class GetAllPredictionsResponse extends BaseApiResponse {
  final List<PredictionResponse> predictions;

  GetAllPredictionsResponse.fromJson(super.json)
      : predictions = (json['data'] as List)
            .map((prediction) => PredictionResponse.fromJson(prediction))
            .toList(),
        super.fromJson();
}
