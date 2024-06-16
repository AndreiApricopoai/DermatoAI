import 'package:flutter/material.dart';
import 'package:frontend_flutter/actions/conversations_actions.dart';
import 'package:frontend_flutter/api/models/responses/conversation_responses/conversation_response.dart';
import 'package:frontend_flutter/app/snackbar_manager.dart';
import 'package:frontend_flutter/data_providers/chat_provider.dart';
import 'package:frontend_flutter/screens/messages_screen.dart';
import 'package:provider/provider.dart';
import 'package:frontend_flutter/api/api_calls/conversation_api.dart';
import 'package:frontend_flutter/app/app_main_theme.dart';
import 'package:frontend_flutter/widgets/text_title.dart';
import 'package:frontend_flutter/widgets/loading_overlay.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatScreenBody extends StatefulWidget {
  const ChatScreenBody({super.key});

  @override
  _ChatScreenBodyState createState() => _ChatScreenBodyState();
}

class _ChatScreenBodyState extends State<ChatScreenBody> {
  String searchQuery = "";
  bool isSearching = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ChatProvider>(context, listen: false);
      if (!provider.isLoaded) {
        _fetchConversations();
      }
    });
  }

  Future<void> _fetchConversations() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var response = await ConversationApi.getAllConversations();
      if (response.isSuccess && context.mounted) {
        Provider.of<ChatProvider>(context, listen: false)
            .setConversations(response.conversations);
      } else {
        throw Exception('Failed to fetch conversations');
      }
    } catch (e) {
      if (context.mounted) {
        SnackbarManager.showErrorSnackBar(
            context, "Failed to fetch the conversations");
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65.0,
        backgroundColor: AppMainTheme.blueLevelFive,
        title: isSearching
            ? buildSearchField()
            : const TextTitle(
                color: Colors.white,
                text: 'DermatoAI Chat',
                fontSize: 24.0,
                fontFamily: GoogleFonts.roboto,
                fontWeight: FontWeight.w400,
              ),
        actions: [
          isSearching
              ? IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      isSearching = false;
                      searchQuery = '';
                    });
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      isSearching = true;
                    });
                  },
                ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              iconSize: 32.0,
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () => createNewConversation(context, (isLoading) {
                setState(() {
                  _isLoading = isLoading;
                });
              }),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Consumer<ChatProvider>(
            builder: (context, chatProvider, child) {
              if (chatProvider.conversations.isEmpty) {
                return _buildNoConversationsUI();
              } else {
                return _buildConversationsUI(chatProvider.conversations);
              }
            },
          ),
          if (_isLoading)
            LoadingOverlay(isLoading: _isLoading), // Overlay for loading
        ],
      ),
    );
  }

  Widget buildSearchField() {
    return TextField(
      autofocus: true,
      decoration: InputDecoration(
        hintText: "Enter conversation title",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (value) {
        setState(() {
          searchQuery = value;
        });
      },
    );
  }

  Widget _buildNoConversationsUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off,
            size: 70,
            color: Colors.grey,
          ),
          const SizedBox(height: 10),
          Text(
            'No conversations available.',
            style: GoogleFonts.roboto(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationsUI(List<ConversationResponse> conversations) {
    List<ConversationResponse> filteredConversations = conversations
        .where((conversation) =>
            conversation.title
                ?.toLowerCase()
                .contains(searchQuery.toLowerCase()) ??
            false)
        .toList();

    if (filteredConversations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off,
              size: 70,
              color: Colors.grey,
            ),
            const SizedBox(height: 10),
            Text(
              'No conversations available.',
              style: GoogleFonts.roboto(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
      itemCount: filteredConversations.length,
      itemBuilder: (context, index) {
        var conversation = filteredConversations[index];
        return Card(
          clipBehavior: Clip.antiAlias,
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            title: Text(
              conversation.title ?? 'No Title',
              style: GoogleFonts.roboto(
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
                color: AppMainTheme.blueLevelFive,
              ),
            ),
            subtitle: Text(
              conversation.createdAt ?? 'Date not provided',
              style: GoogleFonts.roboto(
                fontSize: 12.0,
                color: Colors.black54,
              ),
            ),
            onTap: () => _openConversation(conversation.conversationId!),
            trailing: const Icon(Icons.chevron_right,
                color: AppMainTheme.blueLevelFive),
          ),
        );
      },
    );
  }

  void _openConversation(String conversationId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            ConversationScreen(conversationId: conversationId),
      ),
    );
  }
}
