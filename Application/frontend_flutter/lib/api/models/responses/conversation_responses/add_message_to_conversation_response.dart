import 'package:frontend_flutter/api/models/responses/base_response.dart';
import 'package:frontend_flutter/api/models/responses/conversation_responses/message_response.dart';

class AddMessageToConversationResponse extends BaseApiResponse {
  final String? userMessageId;
  final String? assistantMessageId;
  final String? userMessage;
  final String? assistantMessage;

  AddMessageToConversationResponse.fromJson(super.json)
      : userMessageId = json['data']?['userMessage']?['id'],
        assistantMessageId = json['data']?['assistantMessage']?['id'],
        userMessage = json['data']?['userMessage']?['content'],
        assistantMessage = json['data']?['assistantMessage']?['content'],
        super.fromJson();

  MessageResponse toUserMessageResponse() {
    return MessageResponse(
      messageId: userMessageId,
      sender: 'user',
      content: userMessage,
    );
  }

  MessageResponse toAssistantMessageResponse() {
    return MessageResponse(
      messageId: assistantMessageId,
      sender: 'assistant',
      content: assistantMessage,
    );
  }
}
