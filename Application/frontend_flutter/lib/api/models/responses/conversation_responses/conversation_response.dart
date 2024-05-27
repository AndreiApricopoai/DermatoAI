import 'package:frontend_flutter/api/models/responses/base_response.dart';

class ConversationResponse extends BaseApiResponse {
  final String? conversationId;
  final String? title;

  ConversationResponse.fromJson(super.json)
      : conversationId = json['data']?['id'],
        title = json['data']?['title'],
        super.fromJson();
}
