import 'package:frontend_flutter/api/models/responses/base_response.dart';

class AddMessageToConversationResponse extends BaseApiResponse {
  final String? userId;
  final String? assistantId;
  final String? userMessage;
  final String? assistantMessage;

  AddMessageToConversationResponse.fromJson(super.json)
      : userId = json['data']?['userMessage']?['id'],
        assistantId = json['data']?['assistantMessage']?['id'],
        userMessage = json['data']?['userMessage']?['content'],
        assistantMessage = json['data']?['userMessage']?['content'],
        super.fromJson();
}
