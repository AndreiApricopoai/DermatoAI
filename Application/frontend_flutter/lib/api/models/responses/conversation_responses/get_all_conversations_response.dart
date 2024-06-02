import 'package:frontend_flutter/api/models/responses/base_response.dart';
import 'package:frontend_flutter/api/models/responses/conversation_responses/conversation_response.dart';

class GetAllConversationsResponse extends BaseApiResponse {
  final List<ConversationResponse> conversations;

  GetAllConversationsResponse.fromJson(Map<String, dynamic> json)
      : conversations = (json['data']! as List).map((item) => ConversationResponse.fromJson(item as Map<String, dynamic>)).toList(),
        super.fromJson(json);
}
