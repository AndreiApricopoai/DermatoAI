class GetConversationRequest {
  final String conversationId;

  GetConversationRequest({
    required this.conversationId,
  });

  String getUrl(String baseUrl) {
    return '$baseUrl/$conversationId';
  }
}
