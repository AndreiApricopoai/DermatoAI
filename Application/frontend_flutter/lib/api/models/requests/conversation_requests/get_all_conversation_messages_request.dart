class GetAllConversationMessagesRequest {
  final String conversationId;
  final int? page;
  final int? limit;

  GetAllConversationMessagesRequest({
    required this.conversationId,
    this.page,
    this.limit,
  });

  String getUrl(String baseUrl) {
    return '$baseUrl/$conversationId';
  }

  Map<String, String> toQueryParameters() {
    final Map<String, String> queryParams = {};

    if (page != null) queryParams['page'] = page.toString();
    if (limit != null) queryParams['limit'] = limit.toString();

    return queryParams;
  }
}
