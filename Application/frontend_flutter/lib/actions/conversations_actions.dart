import 'package:flutter/material.dart';
import 'package:frontend_flutter/api/models/requests/conversation_requests/create_conversation_request.dart';
import 'package:frontend_flutter/api/models/requests/conversation_requests/delete_conversation_request.dart';
import 'package:frontend_flutter/api/models/requests/conversation_requests/patch_conversation_request.dart';
import 'package:frontend_flutter/api/models/responses/conversation_responses/conversation_response.dart';
import 'package:frontend_flutter/app/app_main_theme.dart';
import 'package:frontend_flutter/app/snackbar_manager.dart';
import 'package:frontend_flutter/data_providers/chat_provider.dart';
import 'package:frontend_flutter/widgets/custom_alert_dialog.dart';
import 'package:frontend_flutter/validators/input_validators.dart';
import 'package:provider/provider.dart';
import 'package:frontend_flutter/api/api_calls/conversation_api.dart';

void createNewConversation(BuildContext context, Function setLoadingState) {
  final formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return CustomAlertDialog(
        title: 'Create Conversation',
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              floatingLabelStyle: const TextStyle(
                color: AppMainTheme.blueLevelFive,
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppMainTheme.blueLevelFive,
                  width: 2.0,
                ),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppMainTheme.black,
                  width: 1.0,
                ),
              ),
              labelText: 'Title',
              labelStyle: TextStyle(
                color: AppMainTheme.black.withOpacity(0.6),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            validator: InputValidators.createConversationValidator,
          ),
        ),
        cancelButtonText: 'Cancel',
        confirmButtonText: 'Create',
        onCancel: () => Navigator.of(context).pop(),
        onConfirm: () async {
          if (formKey.currentState!.validate()) {
            setLoadingState(true);

            try {
              var request = CreateConversationRequest(title: controller.text);
              var response = await ConversationApi.createConversation(request);
              if (response.isSuccess && context.mounted) {
                Provider.of<ChatProvider>(context, listen: false)
                    .addConversation(response.toConversationResponse());
                Navigator.of(context).pop();
              } else {
                if (context.mounted) {
                  SnackbarManager.showErrorSnackBar(
                      context, "Failed to create conversation");
                }
              }
            } catch (e) {
              if (context.mounted) {
                SnackbarManager.showErrorSnackBar(
                    context, "An error occurred while creating conversation");
              }
            } finally {
              setLoadingState(false);
            }
          }
        },
      );
    },
  );
}

void showEditDialog(BuildContext context, String conversationId, String title,
    Function setLoadingState) {
  final formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController(text: title);

  showDialog(
    context: context,
    builder: (context) {
      return CustomAlertDialog(
        title: 'Edit Conversation',
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: titleController,
            decoration: InputDecoration(
              floatingLabelStyle: const TextStyle(
                color: AppMainTheme.blueLevelFive,
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppMainTheme.blueLevelFive,
                  width: 2.0,
                ),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppMainTheme.black,
                  width: 1.0,
                ),
              ),
              labelText: 'Title',
              labelStyle: TextStyle(
                color: AppMainTheme.black.withOpacity(0.6),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            validator: InputValidators.updateConversationValidator,
          ),
        ),
        cancelButtonText: 'Cancel',
        confirmButtonText: 'Save',
        onCancel: () => Navigator.of(context).pop(),
        onConfirm: () async {
          if (formKey.currentState!.validate()) {
            setLoadingState(true);

            try {
              PatchConversationRequest patchRequest = PatchConversationRequest(
                conversationId: conversationId,
                title: titleController.text,
              );

              var response =
                  await ConversationApi.patchConversation(patchRequest);
              if (response.isSuccess && context.mounted) {
                ConversationResponse updatedConversation =
                    response.toConversationResponse();
                Provider.of<ChatProvider>(context, listen: false)
                    .updateConversation(updatedConversation);
                Navigator.of(context).pop();
              } else {
                if (context.mounted) {
                  SnackbarManager.showErrorSnackBar(
                      context, "Failed to update conversation");
                }
              }
            } catch (e) {
              if (context.mounted) {
                SnackbarManager.showErrorSnackBar(
                    context, "An error occurred while updating conversation");
              }
            } finally {
              setLoadingState(false);
            }
          }
        },
      );
    },
  );
}

void showDeleteDialog(
    BuildContext context, String conversationId, Function setLoadingState) {
  showDialog(
    context: context,
    builder: (context) {
      return CustomAlertDialog(
        title: 'Confirm Deletion',
        content:
            const Text('Are you sure you want to delete this conversation?'),
        cancelButtonText: 'Cancel',
        confirmButtonText: 'Delete',
        onCancel: () => Navigator.of(context).pop(),
        onConfirm: () async {
          setLoadingState(true);

          try {
            DeleteConversationRequest request =
                DeleteConversationRequest(conversationId: conversationId);
            var response = await ConversationApi.deleteConversation(request);

            if (response.isSuccess && context.mounted) {
              Navigator.of(context).pop();
              Navigator.of(context).pop();

              Provider.of<ChatProvider>(context, listen: false)
                  .removeConversation(conversationId);
            } else {
              if (context.mounted) {
                SnackbarManager.showErrorSnackBar(
                    context, "Failed to delete conversation");
              }
            }
          } catch (e) {
            if (context.mounted) {
              SnackbarManager.showErrorSnackBar(
                  context, "An error occurred while deleting conversation");
            }
          } finally {
            setLoadingState(false);
          }
        },
      );
    },
  );
}
