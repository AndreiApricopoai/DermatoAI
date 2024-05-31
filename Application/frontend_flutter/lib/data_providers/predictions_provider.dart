import 'package:flutter/material.dart';
import 'package:frontend_flutter/api/api_calls/prediction_api.dart';
import 'package:frontend_flutter/api/models/responses/prediction_responses/get_all_predictions_response.dart';
import 'package:frontend_flutter/api/models/responses/prediction_responses/prediction_response.dart';

class PredictionsProvider with ChangeNotifier {
  List<PredictionResponse> _predictions = [];
  bool _isLoading = false;

  List<PredictionResponse> get predictions => _predictions;
  bool get isLoading => _isLoading;

  Future<void> fetchPredictions() async {
    _isLoading = true;
    notifyListeners();
    try {
      GetAllPredictionsResponse response = await PredictionApi.getAllPredictions();
      _predictions = response.predictions;
      for (PredictionResponse prediction in _predictions) {
        print(prediction.title);
      }
    } catch (e) {
      print("Failed to fetch predictions: $e");
      // Handle exceptions by showing an error message or similar
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
