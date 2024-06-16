import 'package:flutter/material.dart';
import 'package:frontend_flutter/api/models/responses/conversation_responses/conversation_response.dart';
import 'package:frontend_flutter/api/models/responses/conversation_responses/message_response.dart';

class ChatProvider with ChangeNotifier {
  List<ConversationResponse> _conversations = [];
  Map<String, List<MessageResponse>> _messages = {};
  bool _isLoaded = false;

  List<ConversationResponse> get conversations => _conversations;
  Map<String, List<MessageResponse>> get messages => _messages;
  bool get isLoaded => _isLoaded;

  void setConversations(List<ConversationResponse> conversations) {
    _conversations = conversations;
    _isLoaded = true;
    notifyListeners();
  }

  void addConversation(ConversationResponse conversation) {
    _conversations.insert(0, conversation);
    notifyListeners();
  }

  void removeConversation(String conversationId) {
    _conversations.removeWhere((conv) => conv.conversationId == conversationId);
    _messages.remove(conversationId);
    notifyListeners();
  }

  void updateConversation(ConversationResponse updatedConversation) {
    int index = _conversations.indexWhere((conv) => conv.conversationId == updatedConversation.conversationId);
    if (index != -1) {
      _conversations[index] = updatedConversation;
      notifyListeners();
    }
  }

  void setMessages(String conversationId, List<MessageResponse> messages) {
    _messages[conversationId] = messages;
    notifyListeners();
  }

  void addMessage(String conversationId, MessageResponse message) {
    if (_messages.containsKey(conversationId)) {
      _messages[conversationId]?.add(message);
    } else {
      _messages[conversationId] = [message];
    }
    notifyListeners();
  }

  void setIsLoaded(bool isLoaded) {
    _isLoaded = isLoaded;
    notifyListeners();
  }
}
