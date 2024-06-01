import 'package:frontend_flutter/api/models/requests/feedback_requests/create_feedback_request.dart';
import 'package:frontend_flutter/api/models/responses/base_response.dart';
import 'package:http/http.dart' as http;
import 'package:frontend_flutter/api/api_calls/base_api.dart';
import 'dart:convert';
import 'dart:io';

class FeedbackApi {
  static Future<BaseApiResponse> sendFeedback(
      CreateFeedbackRequest createFeedbackRequest) async {
    try {
      request() async {
        final url = BaseApi.getUri('feedbacks');
        final body = createFeedbackRequest.toJson();
        final headers = BaseApi.getHeadersWithAuthorization();
        return await http.post(url, headers: headers, body: body);
      }

      var response = await BaseApi.performRequestWithRetry(request);
      var jsonResponse = jsonDecode(response.body);
      BaseApiResponse feedbackResponse = BaseApiResponse.fromJson(jsonResponse);
      return feedbackResponse;
    } on SocketException {
      throw Exception(
          'Unable to connect to the server. Please check your internet connection');
    } on FormatException {
      throw Exception('Could not send feedback. Please try again later');
    } on Exception {
      throw Exception('Unexpected error occurred');
    }
  }
}
