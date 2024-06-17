import 'package:flutter/material.dart';
import 'package:frontend_flutter/actions/conversations_actions.dart';
import 'package:frontend_flutter/api/models/requests/conversation_requests/get_all_conversation_messages_request.dart';
import 'package:frontend_flutter/api/models/requests/conversation_requests/add_message_to_conversation_request.dart';
import 'package:frontend_flutter/api/models/responses/conversation_responses/conversation_response.dart';
import 'package:frontend_flutter/app/app_main_theme.dart';
import 'package:frontend_flutter/app/session_manager.dart';
import 'package:frontend_flutter/app/snackbar_manager.dart';
import 'package:frontend_flutter/data_providers/chat_provider.dart';
import 'package:frontend_flutter/widgets/text_title.dart';
import 'package:frontend_flutter/widgets/loading_overlay.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:frontend_flutter/api/api_calls/conversation_api.dart';

class ConversationScreen extends StatefulWidget {
  final String conversationId;
  final String? prefilledMessage;

  const ConversationScreen({
    super.key,
    required this.conversationId,
    this.prefilledMessage,
  });

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? profilePhoto;
  String initials = '';
  bool _isSending = false;
  bool _isLoading = false;
  late String _title;

  @override
  void initState() {
    super.initState();
    profilePhoto = SessionManager.getProfilePhoto();
    String firstName = SessionManager.getFirstName() ?? '';
    String lastName = SessionManager.getLastName() ?? '';
    initials =
        '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}';

    if (widget.prefilledMessage != null) {
      _messageController.text = widget.prefilledMessage!;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchMessages();
    });
  }

  Future<void> _fetchMessages() async {
    try {
      var request = GetAllConversationMessagesRequest(
          conversationId: widget.conversationId);
      var response = await ConversationApi.getAllConversationMessages(request);
      if (response.isSuccess && context.mounted) {
        Provider.of<ChatProvider>(context, listen: false)
            .setMessages(widget.conversationId, response.messages);
      } else {
        throw Exception('Failed to fetch messages');
      }
    } catch (e) {
      if (context.mounted) {
        SnackbarManager.showErrorSnackBar(
            context, "Could not fetch the messages");
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            toolbarHeight: 65.0,
            backgroundColor: AppMainTheme.blueLevelFive,
            title: Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                var conversation = chatProvider.conversations.firstWhere(
                  (conv) => conv.conversationId == widget.conversationId,
                  orElse: () =>
                      ConversationResponse(conversationId: '', title: ''),
                );
                _title = conversation.title ?? '';

                return TextTitle(
                  color: Colors.white,
                  text: conversation.title ?? '',
                  fontSize: 21.0,
                  fontFamily: GoogleFonts.roboto,
                  fontWeight: FontWeight.w400,
                );
              },
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () => showEditDialog(
                    context, widget.conversationId, _title, (isLoading) {
                  setState(() {
                    _isLoading = isLoading;
                  });
                }),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.white),
                  onPressed: () => showDeleteDialog(
                      context, widget.conversationId, (isLoading) {
                    setState(() {
                      _isLoading = isLoading;
                    });
                  }),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: Consumer<ChatProvider>(
                  builder: (context, chatProvider, child) {
                    var messages =
                        chatProvider.messages[widget.conversationId] ?? [];

                    if (messages.isEmpty) {
                      return const Center(
                          child: Text("No messages available",
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.grey)));
                    } else {
                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          var message = messages[index];
                          bool isUser = message.sender == 'user';

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 16.0),
                            child: Align(
                              alignment: isUser
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                padding: const EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  color: isUser
                                      ? Colors.white
                                      : AppMainTheme.blueLevelFive
                                          .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (!isUser)
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor:
                                                AppMainTheme.blueLevelFive,
                                            child: Image.asset(
                                                'assets/icons/app_logo_white2.png',
                                                width: 25.0),
                                          ),
                                          const SizedBox(width: 8.0),
                                          Text(
                                            'DermatoAI',
                                            style: GoogleFonts.roboto(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                              color: AppMainTheme.blueLevelFive,
                                            ),
                                          ),
                                        ],
                                      ),
                                    if (isUser)
                                      Row(
                                        children: [
                                          profilePhoto != null &&
                                                  profilePhoto!.isNotEmpty
                                              ? CircleAvatar(
                                                  radius: 20,
                                                  backgroundImage: NetworkImage(
                                                      profilePhoto!),
                                                )
                                              : CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor:
                                                      AppMainTheme.black,
                                                  child: Text(
                                                    initials,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                          const SizedBox(width: 8.0),
                                          Text(
                                            'Me',
                                            style: GoogleFonts.roboto(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                              color: AppMainTheme.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    const SizedBox(height: 10.0),
                                    Text(
                                      message.content ?? '',
                                      style: GoogleFonts.roboto(
                                        fontSize: 16.0,
                                        color: isUser
                                            ? Colors.black
                                            : AppMainTheme.blueLevelFive,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 30.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: "Ask a dermatological question...",
                          hintStyle: TextStyle(
                            color: AppMainTheme.black.withOpacity(0.4),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                                color: AppMainTheme.blueLevelFive),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                                color: AppMainTheme.blueLevelFive, width: 2.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                                color: AppMainTheme.blueLevelFive, width: 2.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    CircleAvatar(
                      backgroundColor: AppMainTheme.blueLevelFive,
                      child: _isSending
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : IconButton(
                              icon: const Icon(Icons.send, color: Colors.white),
                              onPressed: () =>
                                  _sendMessage(context, widget.conversationId),
                            ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        LoadingOverlay(isLoading: _isLoading),
      ],
    );
  }

  void _sendMessage(BuildContext context, String conversationId) async {
    String messageContent = _messageController.text.trim();
    if (messageContent.isNotEmpty) {
      setState(() {
        _isSending = true;
      });

      try {
        var request = AddMessageToConversationRequest(
          conversationId: conversationId,
          messageContent: messageContent,
        );
        var response = await ConversationApi.addMessageToConversation(request);
        if (response.isSuccess && context.mounted) {
          Provider.of<ChatProvider>(context, listen: false)
              .addMessage(conversationId, response.toUserMessageResponse());
          Provider.of<ChatProvider>(context, listen: false).addMessage(
              conversationId, response.toAssistantMessageResponse());

          _messageController.clear();
          _scrollToBottom(); // Scroll to the bottom
        } else {
          if (context.mounted) {
            SnackbarManager.showErrorSnackBar(
                context, "Could not send the message");
          }
        }
      } catch (e) {
        if (context.mounted) {
          SnackbarManager.showErrorSnackBar(
              context, "Could not send the message");
        }
      } finally {
        setState(() {
          _isSending = false;
        });
      }
    }
  }
}
