import 'package:frontend_flutter/api/models/requests/prediction_requests/delete_prediction_request.dart';
import 'package:frontend_flutter/api/models/requests/prediction_requests/get_prediction_request.dart';
import 'package:frontend_flutter/api/models/requests/prediction_requests/patch_prediction_request.dart';
import 'package:frontend_flutter/api/models/responses/base_response.dart';
import 'package:frontend_flutter/api/models/responses/prediction_responses/get_all_predictions_response.dart';
import 'package:frontend_flutter/api/models/responses/prediction_responses/prediction_response.dart';
import 'package:http/http.dart' as http;
import 'package:frontend_flutter/api/api_calls/base_api.dart';
import 'dart:convert';
import 'dart:io';

class PredictionApi {
  static Future<PredictionResponse> getPrediction(
      GetPredictionRequest getPredictionRequest) async {
    try {
      request() async {
        final urlSuffix = getPredictionRequest.getUrl('predictions');
        final url = BaseApi.getUri(urlSuffix);
        final headers = BaseApi.getHeadersWithAuthorization();
        return await http.get(url, headers: headers);
      }

      var response = await BaseApi.performRequestWithRetry(request);
      var jsonResponse = jsonDecode(response.body);
      PredictionResponse predictionResponse =
          PredictionResponse.fromJson(jsonResponse);
      return predictionResponse;
    } on SocketException {
      throw Exception(
          'Unable to connect to the server. Please check your internet connection');
    } on FormatException {
      throw Exception('Could not get prediction. Please try again later');
    } on Exception {
      throw Exception('Unexpected error occurred');
    }
  }

  static Future<GetAllPredictionsResponse> getAllPredictions() async {
    try {
      request() async {
        final url = BaseApi.getUri('predictions');
        final headers = BaseApi.getHeadersWithAuthorization();
        return await http.get(url, headers: headers);
      }

      var response = await BaseApi.performRequestWithRetry(request);
      var jsonResponse = jsonDecode(response.body);
      GetAllPredictionsResponse getAllPredictionsResponse =
          GetAllPredictionsResponse.fromJson(jsonResponse);
      return getAllPredictionsResponse;
    } on SocketException {
      throw Exception(
          'Unable to connect to the server. Please check your internet connection');
    } on FormatException {
      throw Exception('Could not get predictions. Please try again later');
    } on Exception {
      throw Exception('Unexpected error occurred');
    }
  }

  static Future<void> createPrediction() async {
    // try {
    //   request() async {
    //     final url = BaseApi.getUri('conversations');
    //     final body = jsonEncode(createConversationRequest.toJson());
    //     final headers = BaseApi.getHeadersWithAuthorization();
    //     return await http.post(url, headers: headers, body: body);
    //   }

    //   var response = await BaseApi.performRequestWithRetry(request);
    //   var jsonResponse = jsonDecode(response.body);
    //   ConversationResponse conversationResponse =
    //       ConversationResponse.fromJson(jsonResponse);
    //   return conversationResponse;
    // } on SocketException {
    //   throw Exception(
    //       'Unable to connect to the server. Please check your internet connection');
    // } on FormatException {
    //   throw Exception('Could not create conversation. Please try again later');
    // } on Exception {
    //   throw Exception('Unexpected error occurred');
    // }
  }

  static Future<PredictionResponse> patchPrediction(
      PatchPredictionRequest patchPredictionRequest) async {
    try {
      request() async {
        final urlSuffix = patchPredictionRequest.getUrl('predictions');
        final url = BaseApi.getUri(urlSuffix);
        final body = jsonEncode(patchPredictionRequest.toJson());
        final headers = BaseApi.getHeadersWithAuthorization();
        return await http.patch(url, headers: headers, body: body);
      }

      var response = await BaseApi.performRequestWithRetry(request);
      var jsonResponse = jsonDecode(response.body);
      PredictionResponse predictionResponse =
          PredictionResponse.fromJson(jsonResponse);
      return predictionResponse;
    } on SocketException {
      throw Exception(
          'Unable to connect to the server. Please check your internet connection');
    } on FormatException {
      throw Exception('Could not update prediction. Please try again later');
    } on Exception {
      throw Exception('Unexpected error occurred');
    }
  }

  static Future<BaseApiResponse> deletePrediction(
      DeletePredictionRequest deletePredictionRequest) async {
    try {
      request() async {
        final urlSuffix = deletePredictionRequest.getUrl('predictions');
        final url = BaseApi.getUri(urlSuffix);
        final headers = BaseApi.getHeadersWithAuthorization();
        return await http.delete(url, headers: headers);
      }

      var response = await BaseApi.performRequestWithRetry(request);
      var jsonResponse = jsonDecode(response.body);
      BaseApiResponse deletePredictionResponse =
          BaseApiResponse.fromJson(jsonResponse);
      return deletePredictionResponse;
    } on SocketException {
      throw Exception(
          'Unable to connect to the server. Please check your internet connection');
    } on FormatException {
      throw Exception('Could not delete prediction. Please try again');
    } on Exception {
      throw Exception('Unexpected error occurred');
    }
  }
}
