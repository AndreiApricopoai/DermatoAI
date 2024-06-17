import 'package:frontend_flutter/api/models/responses/base_response.dart';
import 'package:frontend_flutter/api/models/responses/conversation_responses/conversation_response.dart';
import 'package:intl/intl.dart';

class GetConversationResponse extends BaseApiResponse {
  final String? conversationId;
  final String? title;
  final String? createdAt;

  GetConversationResponse.fromJson(super.json)
      : conversationId = json['data']?['id'],
        title = json['data']?['title'],
        createdAt = formatDate(json['data']?['createdAt']),
        super.fromJson();

  ConversationResponse toConversationResponse() {
    return ConversationResponse(
      conversationId: conversationId,
      title: title,
      createdAt: createdAt,
    );
  }

  static String? formatDate(String? isoDate) {
    if (isoDate == null) return null;
    DateTime date = DateTime.parse(isoDate);
    return DateFormat('dd-MM-yyyy').format(date);
  }
}
