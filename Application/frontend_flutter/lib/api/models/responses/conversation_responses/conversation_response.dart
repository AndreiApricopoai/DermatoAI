import 'package:intl/intl.dart';

class ConversationResponse {
  final String? conversationId;
  final String? title;
  final String? createdAt;

  ConversationResponse({this.createdAt, this.conversationId, this.title});

  ConversationResponse.fromJson(Map<String, dynamic> json)
      : conversationId = json['id'],
        title = json['title'],
        createdAt = formatDate(json['createdAt']);

  static String? formatDate(String? isoDate) {
    if (isoDate == null) return null;
    DateTime date = DateTime.parse(isoDate);
    return DateFormat('dd-MM-yyyy').format(date);
  }
}
