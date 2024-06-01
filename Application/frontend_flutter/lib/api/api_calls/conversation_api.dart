import 'package:frontend_flutter/api/models/requests/conversation_requests/add_message_to_conversation_request.dart';
import 'package:frontend_flutter/api/models/requests/conversation_requests/create_conversation_request.dart';
import 'package:frontend_flutter/api/models/requests/conversation_requests/delete_conversation_request.dart';
import 'package:frontend_flutter/api/models/requests/conversation_requests/get_all_conversation_messages_request.dart';
import 'package:frontend_flutter/api/models/requests/conversation_requests/get_conversation_request.dart';
import 'package:frontend_flutter/api/models/requests/conversation_requests/patch_conversation_request.dart';
import 'package:frontend_flutter/api/models/responses/base_response.dart';
import 'package:frontend_flutter/api/models/responses/conversation_responses/add_message_to_conversation_response.dart';
import 'package:frontend_flutter/api/models/responses/conversation_responses/conversation_response.dart';
import 'package:frontend_flutter/api/models/responses/conversation_responses/get_all_conversations_response.dart';
import 'package:frontend_flutter/api/models/responses/conversation_responses/get_all_messages_from_conversation_response.dart';
import 'package:http/http.dart' as http;
import 'package:frontend_flutter/api/api_calls/base_api.dart';
import 'dart:convert';
import 'dart:io';

class ConversationApi {
  static Future<ConversationResponse> getConversation(
      GetConversationRequest getConversationRequest) async {
    try {
      request() async {
        final urlSuffix = getConversationRequest.getUrl('conversations');
        final url = BaseApi.getUri(urlSuffix);
        final headers = BaseApi.getHeadersWithAuthorization();
        return await http.get(url, headers: headers);
      }

      var response = await BaseApi.performRequestWithRetry(request);
      var jsonResponse = jsonDecode(response.body);
      ConversationResponse conversationResponse =
          ConversationResponse.fromJson(jsonResponse);
      return conversationResponse;
    } on SocketException {
      throw Exception(
          'Unable to connect to the server. Please check your internet connection');
    } on FormatException {
      throw Exception('Could not get conversation. Please try again later');
    } on Exception {
      throw Exception('Unexpected error occurred');
    }
  }

  static Future<GetAllConversationsResponse> getAllConversations() async {
    try {
      request() async {
        final url = BaseApi.getUri('conversations');
        final headers = BaseApi.getHeadersWithAuthorization();
        return await http.get(url, headers: headers);
      }

      var response = await BaseApi.performRequestWithRetry(request);
      var jsonResponse = jsonDecode(response.body);
      GetAllConversationsResponse getAllConversationsResponse =
          GetAllConversationsResponse.fromJson(jsonResponse);
      return getAllConversationsResponse;
    } on SocketException {
      throw Exception(
          'Unable to connect to the server. Please check your internet connection');
    } on FormatException {
      throw Exception('Could not get conversations. Please try again later');
    } on Exception {
      throw Exception('Unexpected error occurred');
    }
  }

  static Future<ConversationResponse> createConversation(
      CreateConversationRequest createConversationRequest) async {
    try {
      request() async {
        final url = BaseApi.getUri('conversations');
        final body = createConversationRequest.toJson();
        final headers = BaseApi.getHeadersWithAuthorization();
        return await http.post(url, headers: headers, body: body);
      }

      var response = await BaseApi.performRequestWithRetry(request);
      var jsonResponse = jsonDecode(response.body);
      ConversationResponse conversationResponse =
          ConversationResponse.fromJson(jsonResponse);
      return conversationResponse;
    } on SocketException {
      throw Exception(
          'Unable to connect to the server. Please check your internet connection');
    } on FormatException {
      throw Exception('Could not create conversation. Please try again later');
    } on Exception {
      throw Exception('Unexpected error occurred');
    }
  }

  static Future<ConversationResponse> patchConversation(
      PatchConversationRequest patchConversationRequest) async {
    try {
      request() async {
        final urlSuffix = patchConversationRequest.getUrl('conversations');
        final url = BaseApi.getUri(urlSuffix);
        final body = patchConversationRequest.toJson();
        final headers = BaseApi.getHeadersWithAuthorization();
        return await http.patch(url, headers: headers, body: body);
      }

      var response = await BaseApi.performRequestWithRetry(request);
      var jsonResponse = jsonDecode(response.body);
      ConversationResponse conversationResponse =
          ConversationResponse.fromJson(jsonResponse);
      return conversationResponse;
    } on SocketException {
      throw Exception(
          'Unable to connect to the server. Please check your internet connection');
    } on FormatException {
      throw Exception('Could not update conversation. Please try again later');
    } on Exception {
      throw Exception('Unexpected error occurred');
    }
  }

  static Future<BaseApiResponse> deleteConversation(
      DeleteConversationRequest deleteConversationRequest) async {
    try {
      request() async {
        final urlSuffix = deleteConversationRequest.getUrl('conversations');
        final url = BaseApi.getUri(urlSuffix);
        final headers = BaseApi.getHeadersWithAuthorization();
        return await http.delete(url, headers: headers);
      }

      var response = await BaseApi.performRequestWithRetry(request);
      var jsonResponse = jsonDecode(response.body);
      BaseApiResponse deleteConversationResponse =
          BaseApiResponse.fromJson(jsonResponse);
      return deleteConversationResponse;
    } on SocketException {
      throw Exception(
          'Unable to connect to the server. Please check your internet connection');
    } on FormatException {
      throw Exception('Could not delete conversation. Please try again later');
    } on Exception {
      throw Exception('Unexpected error occurred');
    }
  }

  static Future<GetAllConversationMessagesResponse> getAllConversationMessages(
      GetAllConversationMessagesRequest
          getAllConversationMessagesRequest) async {
    try {
      request() async {
        final urlSuffix =
            getAllConversationMessagesRequest.getUrl('conversations');
        final queryParameters =
            getAllConversationMessagesRequest.toQueryParameters();
        final url =
            BaseApi.getUriWithQueryParameters(urlSuffix, queryParameters);
        final headers = BaseApi.getHeadersWithAuthorization();
        return await http.get(url, headers: headers);
      }

      var response = await BaseApi.performRequestWithRetry(request);
      var jsonResponse = jsonDecode(response.body);
      GetAllConversationMessagesResponse getAllConversationMessagesResponse =
          GetAllConversationMessagesResponse.fromJson(jsonResponse);
      return getAllConversationMessagesResponse;
    } on SocketException {
      throw Exception(
          'Unable to connect to the server. Please check your internet connection');
    } on FormatException {
      throw Exception(
          'Could not get messages from conversation. Please try again later');
    } on Exception {
      throw Exception('Unexpected error occurred');
    }
  }

  static Future<AddMessageToConversationResponse> addMessageToConversation(
      AddMessageToConversationRequest addMessageToConversationRequest) async {
    try {
      request() async {
        final urlSuffix =
            addMessageToConversationRequest.getUrl('conversations');
        final url = BaseApi.getUri(urlSuffix);
        final body = addMessageToConversationRequest.toJson();
        final headers = BaseApi.getHeadersWithAuthorization();
        return await http.post(url, headers: headers, body: body);
      }

      var response = await BaseApi.performRequestWithRetry(request);
      var jsonResponse = jsonDecode(response.body);
      AddMessageToConversationResponse addMessageToConversationResponse =
          AddMessageToConversationResponse.fromJson(jsonResponse);
      return addMessageToConversationResponse;
    } on SocketException {
      throw Exception(
          'Unable to connect to the server. Please check your internet connection');
    } on FormatException {
      throw Exception(
          'Could not add message to conversation. Please try again later');
    } on Exception {
      throw Exception('Unexpected error occurred');
    }
  }
}
