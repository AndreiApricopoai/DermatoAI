import 'dart:convert';

class PatchConversationRequest {
  final String conversationId;
  final String? title;

  PatchConversationRequest({
    required this.conversationId,
    this.title,
  });

  String toJson() {
    final Map<String, dynamic> data = {};
    if (title != null) data['title'] = title;
    return json.encode(data);
  }

  String getUrl(String baseUrl) {
    return '$baseUrl/$conversationId';
  }
}
