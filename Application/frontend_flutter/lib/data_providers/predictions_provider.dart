import 'package:flutter/material.dart';
import 'package:frontend_flutter/api/api_calls/prediction_api.dart';
import 'package:frontend_flutter/api/models/responses/prediction_responses/get_all_predictions_response.dart';
import 'package:frontend_flutter/api/models/responses/prediction_responses/prediction_response.dart';

class PredictionsProvider with ChangeNotifier {
  List<Prediction> _predictions = [];
  List<String> _deletedPredictionIds = [];
  bool _isLoading = false;

  List<Prediction> get predictions => _predictions;
  bool get isLoading => _isLoading;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> fetchPredictions() async {
    setLoading(true);
    try {
      GetAllPredictionsResponse response = await PredictionApi.getAllPredictions();
      _predictions = response.predictions;
    } catch (e) {
      print("Failed to fetch predictions: $e");
    } finally {
      setLoading(false);
    }
  }

  void addPrediction(Prediction prediction) {
    int index = _predictions.indexWhere((p) => p.predictionId == prediction.predictionId);
          print("0000000000000000000000000000000000000");

    if (index != -1) {
      print("1111111111111111111111111111111111111111111111111111");
      if (!_deletedPredictionIds.contains(prediction.predictionId)) {
        _predictions[index] = prediction;
              print("22222222222222222222222222222222222222222222222222222222222222222");

      }
    } else {
                print("444444444444444444444444444444444444444444444444");

      _predictions.add(prediction);
    }
    notifyListeners();
  }

  void deletePrediction(String predictionId) {
    _deletedPredictionIds.add(predictionId);
    _predictions.removeWhere((p) => p.predictionId == predictionId);
    notifyListeners();
  }
}

