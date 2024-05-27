class DeleteConversationRequest {
  final String conversationId;

  DeleteConversationRequest({
    required this.conversationId,
  });

  String getUrl(String baseUrl) {
    return '$baseUrl/$conversationId';
  }
}