import 'package:flutter/material.dart';
import 'package:frontend_flutter/api/models/requests/conversation_requests/create_conversation_request.dart';
import 'package:frontend_flutter/data_providers/chat_provider.dart';
import 'package:frontend_flutter/screens/conversation_screen.dart';
import 'package:provider/provider.dart';
import 'package:frontend_flutter/api/api_calls/conversation_api.dart';

class ChatScreenBody extends StatefulWidget {
  @override
  _ChatScreenBodyState createState() => _ChatScreenBodyState();
}

class _ChatScreenBodyState extends State<ChatScreenBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchConversations();
    });
  }

  Future<void> _fetchConversations() async {
    try {
      var response = await ConversationApi.getAllConversations();
      if (response.isSuccess) {
        Provider.of<ChatProvider>(context, listen: false).setConversations(response.conversations);
      } else {
        throw Exception('Failed to fetch conversations');
      }
    } catch (e) {
      print('Error fetching conversations: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        if (chatProvider.conversations.isEmpty) {
          return _buildNoConversationsUI();
        } else {
          return _buildConversationsUI(chatProvider);
        }
      },
    );
  }

  Widget _buildNoConversationsUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('No conversations available'),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _createNewConversation(),
            child: Text('Create Conversation'),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationsUI(ChatProvider chatProvider) {
    return ListView.builder(
      itemCount: chatProvider.conversations.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(chatProvider.conversations[index].title ?? 'No Title'),
          onTap: () => _openConversation(chatProvider.conversations[index].conversationId!),
        );
      },
    );
  }

  void _createNewConversation() {
    final TextEditingController _controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create Conversation'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: "Enter title"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String title = _controller.text.trim();
                if (title.isNotEmpty) {
                  try {
                    var request = CreateConversationRequest(title: title);
                    var response = await ConversationApi.createConversation(request);
                    if (response.isSuccess) {
                      Provider.of<ChatProvider>(context, listen: false).addConversation(response.toConversationResponse());
                      Navigator.of(context).pop();
                    } else {
                      // Handle failure
                    }
                  } catch (e) {
                    // Handle error
                  }
                }
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _openConversation(String conversationId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ConversationScreen(conversationId: conversationId),
      ),
    );
  }
}
