import 'package:frontend_flutter/api/models/responses/base_response.dart';
import 'package:frontend_flutter/api/models/responses/conversation_responses/conversation_response.dart';

class GetConversationResponse extends BaseApiResponse {
  final String? conversationId;
  final String? title;

  GetConversationResponse.fromJson(super.json)
      : conversationId = json['data']?['id'],
        title = json['data']?['title'],
        super.fromJson();

  ConversationResponse toConversationResponse() {
    return ConversationResponse(
      conversationId: conversationId,
      title: title,
    );
  }
}
