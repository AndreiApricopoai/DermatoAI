import 'package:frontend_flutter/api/models/responses/base_response.dart';
import 'package:frontend_flutter/api/models/responses/conversation_responses/message_response.dart';

class GetAllConversationMessagesResponse extends BaseApiResponse {
  final List<MessageResponse> messages;

  GetAllConversationMessagesResponse.fromJson(super.json)
      : messages = (json['data'] as List)
            .map((message) => MessageResponse.fromJsonElement(message))
            .toList(),
        super.fromJson();
}
