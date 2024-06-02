class ConversationResponse {
  final String? conversationId;
  final String? title;

  ConversationResponse({this.conversationId, this.title});

  ConversationResponse.fromJson(Map<String, dynamic> json)
      : conversationId = json['id'],
        title = json['title'];
}
