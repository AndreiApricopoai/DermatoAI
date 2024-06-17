import 'dart:convert';

class AddMessageToConversationRequest {
  final String conversationId;
  final String messageContent;

  AddMessageToConversationRequest({
    required this.messageContent,
    required this.conversationId,
  });

  String toJson() {
    return json.encode({
      'messageContent': messageContent,
    });
  }

  String getUrl(String baseUrl) {
    return '$baseUrl/$conversationId/messages';
  }
}
