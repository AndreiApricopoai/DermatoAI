import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend_flutter/api/api_calls/prediction_api.dart';
import 'package:frontend_flutter/api/models/requests/prediction_requests/create_prediction_request.dart';
import 'package:frontend_flutter/api/models/requests/prediction_requests/get_prediction_request.dart';
import 'package:frontend_flutter/api/models/responses/prediction_responses/get_prediction_response.dart';
import 'package:frontend_flutter/api/models/responses/prediction_responses/prediction_response.dart';
import 'package:frontend_flutter/app/photo_handler.dart';
import 'package:frontend_flutter/app/snackbar_manager.dart';
import 'package:frontend_flutter/data_providers/predictions_provider.dart';

class HomeActions {
  static void checkPredictionStatus(
      String predictionId, BuildContext context, PredictionsProvider provider) {
    const Duration checkInterval = Duration(seconds: 10);
    const Duration timeout = Duration(minutes: 2);

    Timer.periodic(checkInterval, (Timer t) async {
      if (t.tick >= (timeout.inSeconds / checkInterval.inSeconds)) {
        t.cancel();
      }

      try {
        GetPredictionResponse prediction =
            await getPredictionStatus(predictionId);
        if (prediction.isSuccess == false && context.mounted) {
          SnackbarManager.showErrorSnackBar(
              context, 'Failed to get prediction status');
        }
        if (prediction.status != "pending") {
          t.cancel();
          Prediction processedPrediction = prediction.toPrediction();
          provider.addPrediction(processedPrediction);
        }
      } catch (error) {
        if (context.mounted) {
          SnackbarManager.showErrorSnackBar(
              context, 'Failed to get prediction status');
        }
        t.cancel();
      }
    });
  }

  static Future<GetPredictionResponse> getPredictionStatus(
      String predictionId) async {
    GetPredictionRequest request =
        GetPredictionRequest(predictionId: predictionId);
    try {
      GetPredictionResponse response =
          await PredictionApi.getPrediction(request);
      return response;
    } catch (e) {
      throw Exception('Failed to get prediction status');
    }
  }

  static Future<Prediction?> handlePhotoSelection(
      PhotoSource source, BuildContext context) async {
    final photoHandler = PhotoHandler();
    Prediction? prediction;

    try {
      CreatePredictionRequest? createPredictionRequest;
      if (source == PhotoSource.camera) {
        createPredictionRequest = await photoHandler.takePhoto(context);
      } else {
        createPredictionRequest = await photoHandler.pickImage(context);
      }

      if (createPredictionRequest == null) {
        throw Exception('No image selected');
      }

      final response =
          await PredictionApi.createPrediction(createPredictionRequest);

      if (response.isSuccess) {
        prediction = response.toPrediction();
      } else {
        throw Exception('Failed to create prediction');
      }
    } catch (e) {
      if (context.mounted) {
        SnackbarManager.showErrorSnackBar(
            context, 'Failed to create prediction');
      }
    }
    return prediction;
  }
}
