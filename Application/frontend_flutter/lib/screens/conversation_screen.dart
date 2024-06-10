import 'package:flutter/material.dart';
import 'package:frontend_flutter/data_providers/chat_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend_flutter/api/api_calls/conversation_api.dart';
import 'package:frontend_flutter/api/models/requests/conversation_requests/get_all_conversation_messages_request.dart';
import 'package:frontend_flutter/api/models/requests/conversation_requests/add_message_to_conversation_request.dart';
import 'package:frontend_flutter/api/models/requests/conversation_requests/create_conversation_request.dart';
import 'package:frontend_flutter/api/models/requests/conversation_requests/delete_conversation_request.dart';
import 'package:frontend_flutter/api/models/requests/conversation_requests/patch_conversation_request.dart';
import 'package:frontend_flutter/api/models/responses/conversation_responses/conversation_response.dart';
import 'package:frontend_flutter/api/models/responses/base_response.dart';

class ConversationScreen extends StatefulWidget {
  final String conversationId;

  ConversationScreen({required this.conversationId});

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchMessages();
    });
  }

  Future<void> _fetchMessages() async {
    try {
      var request = GetAllConversationMessagesRequest(conversationId: widget.conversationId);
      var response = await ConversationApi.getAllConversationMessages(request);
      if (response.isSuccess) {
        Provider.of<ChatProvider>(context, listen: false).setMessages(widget.conversationId, response.messages);
      } else {
        throw Exception('Failed to fetch messages');
      }
    } catch (e) {
      print('Error fetching messages: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _createNewConversation(context),
          ),
          PopupMenuButton<String>(
            onSelected: (String value) {
              if (value == 'edit') {
                _showEditDialog(context);
              } else if (value == 'delete') {
                _showDeleteDialog(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'edit',
                  child: ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('Edit'),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete),
                    title: Text('Delete'),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                var messages = chatProvider.messages[widget.conversationId] ?? [];

                if (messages.isEmpty) {
                  return Center(child: Text("No messages available", style: TextStyle(fontSize: 20.0, color: Colors.grey)));
                } else {
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(messages[index].content ?? ''),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(hintText: "Enter message"),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _sendMessage(context, widget.conversationId),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _createNewConversation(BuildContext context) {
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to create conversation')),
                      );
                    }
                  } catch (e) {
                    // Handle error
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('An error occurred')),
                    );
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

  void _sendMessage(BuildContext context, String conversationId) async {
    String messageContent = _messageController.text.trim();
    if (messageContent.isNotEmpty) {
      try {
        var request = AddMessageToConversationRequest(
          conversationId: conversationId,
          messageContent: messageContent,
        );
        var response = await ConversationApi.addMessageToConversation(request);
        if (response.isSuccess) {
          Provider.of<ChatProvider>(context, listen: false).addMessage(conversationId, response.toUserMessageResponse());
          Provider.of<ChatProvider>(context, listen: false).addMessage(conversationId, response.toAssistantMessageResponse());

          _messageController.clear();
        } else {
          // Handle failure
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to send message')),
          );
        }
      } catch (e) {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred')),
        );
      }
    }
  }

  void _showEditDialog(BuildContext context) {
    TextEditingController titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Conversation'),
          content: TextField(
            controller: titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () async {
                String newTitle = titleController.text.trim();
                if (newTitle.isNotEmpty) {
                  try {
                    PatchConversationRequest patchRequest = PatchConversationRequest(
                      conversationId: widget.conversationId,
                      title: newTitle,
                    );

                    var response = await ConversationApi.patchConversation(patchRequest);
                    if (response.isSuccess && context.mounted) {
                      ConversationResponse updatedConversation = response.toConversationResponse();
                      Provider.of<ChatProvider>(context, listen: false).updateConversation(updatedConversation);
                      Navigator.of(context).pop(); // Close dialog
                    } else {
                      // Handle failure
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to update conversation')),
                      );
                    }
                  } catch (e) {
                    // Handle error
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('An error occurred')),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this conversation?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                try {
                  DeleteConversationRequest request = DeleteConversationRequest(
                      conversationId: widget.conversationId);
                  var response = await ConversationApi.deleteConversation(request);

                  if (response.isSuccess && context.mounted) {
                    Provider.of<ChatProvider>(context, listen: false).removeConversation(widget.conversationId);
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.of(context).pop(); // Go back to the previous screen if current conversation is deleted
                  } else {
                    // Handle failure
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to delete conversation')),
                    );
                  }
                } catch (e) {
                  // Handle error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('An error occurred')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
