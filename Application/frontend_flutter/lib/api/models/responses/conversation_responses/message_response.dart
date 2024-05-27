import 'package:frontend_flutter/api/models/responses/base_response.dart';

class MessageResponse extends BaseApiResponse {
  final String? messageId;
  final String? sender;
  final String? content;

  MessageResponse.fromJsonElement(super.json)
      : messageId = json['id'],
        sender = json['userId'],
        content = json['title'],
        super.fromJson();
}
