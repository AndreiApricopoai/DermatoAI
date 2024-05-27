import 'dart:convert';

class CreateConversationRequest {
  final String title;

  CreateConversationRequest({
    required this.title,
  });

  String toJson() {
    return json.encode({
      'title': title,
    });
  }
}
