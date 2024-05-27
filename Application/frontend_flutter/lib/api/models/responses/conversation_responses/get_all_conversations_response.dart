import 'package:frontend_flutter/api/models/responses/base_response.dart';
import 'package:frontend_flutter/api/models/responses/conversation_responses/conversation_response.dart';

class GetAllConversationsResponse extends BaseApiResponse {
  final List<ConversationResponse> conversations;

  GetAllConversationsResponse.fromJson(super.json)
      : conversations = (json['data'] as List)
            .map((conversation) => ConversationResponse.fromJson(conversation))
            .toList(),
        super.fromJson();
}
