import 'package:frontend_flutter/api/models/responses/base_response.dart';
import 'package:frontend_flutter/api/models/responses/conversation_responses/message_response.dart';

class GetAllConversationMessagesResponse extends BaseApiResponse {
  final List<MessageResponse> messages;

  GetAllConversationMessagesResponse.fromJson(Map<String, dynamic> json)
      : messages = (json['data']! as List).map((item) => MessageResponse.fromJson(item as Map<String, dynamic>)).toList(),
        super.fromJson(json);
}
