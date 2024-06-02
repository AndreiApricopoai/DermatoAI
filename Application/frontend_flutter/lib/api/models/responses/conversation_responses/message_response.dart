class MessageResponse {
  final String? messageId;
  final String? sender;
  final String? content;

  MessageResponse({this.messageId, this.sender, this.content});

  MessageResponse.fromJson(Map<String, dynamic> json)
      : messageId = json['id'],
        sender = json['sender'],
        content = json['content'];
}
