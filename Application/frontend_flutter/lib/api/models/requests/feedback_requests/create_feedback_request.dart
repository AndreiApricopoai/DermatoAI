import 'dart:convert';

class CreateFeedbackRequest {
  final String category;
  final String content;

  CreateFeedbackRequest({
    required this.category,
    required this.content,
  });

  String toJson() {
    return json.encode({
      'category': category,
      'content': content,
    });
  }
}
