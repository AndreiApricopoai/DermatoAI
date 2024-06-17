import 'package:flutter/material.dart';
import 'package:frontend_flutter/api/api_calls/prediction_api.dart';
import 'package:frontend_flutter/api/models/requests/prediction_requests/delete_prediction_request.dart';
import 'package:frontend_flutter/api/models/requests/prediction_requests/patch_prediction_request.dart';
import 'package:frontend_flutter/api/models/responses/prediction_responses/prediction_response.dart';
import 'package:frontend_flutter/app/snackbar_manager.dart';
import 'package:frontend_flutter/data_providers/predictions_provider.dart';
import 'package:frontend_flutter/app/app_main_theme.dart';
import 'package:frontend_flutter/widgets/custom_alert_dialog.dart';
import 'package:frontend_flutter/validators/input_validators.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class PredictionActions {
  static void showEditDialog(BuildContext context, Prediction prediction,
      Function(bool) setLoading, Function(Prediction) updatePrediction) {
    final formKey = GlobalKey<FormState>();
    TextEditingController titleController =
        TextEditingController(text: prediction.title);
    TextEditingController descriptionController =
        TextEditingController(text: prediction.description);

    showDialog(
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          title: 'Edit Prediction',
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: InputValidators.predictionTitleValidator,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                      color: AppMainTheme.black.withOpacity(0.6),
                    ),
                    labelText: 'Description',
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: InputValidators.predictionDescriptionValidator,
                ),
              ],
            ),
          ),
          cancelButtonText: 'Cancel',
          confirmButtonText: 'Save',
          onCancel: () => Navigator.of(context).pop(),
          onConfirm: () async {
            if (formKey.currentState!.validate()) {
              setLoading(true);
              try {
                PatchPredictionRequest patchRequest = PatchPredictionRequest(
                  predictionId: prediction.predictionId!,
                  title: titleController.text,
                  description: descriptionController.text,
                );

                var response =
                    await PredictionApi.patchPrediction(patchRequest);
                if (response.isSuccess == true && context.mounted) {
                  Prediction updatedPrediction = response.toPrediction();
                  Provider.of<PredictionsProvider>(context, listen: false)
                      .addPrediction(updatedPrediction);
                  updatePrediction(updatedPrediction);
                  Navigator.of(context).pop();
                }
              } catch (e) {
                if (context.mounted) {
                  SnackbarManager.showErrorSnackBar(
                      context, "Failed to update prediction");
                }
              }
              setLoading(false);
            }
          },
        );
      },
    );
  }

  static void showDeleteDialog(BuildContext context, Prediction prediction,
      Function(bool) setLoading, Function deletePrediction) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          title: 'Confirm Deletion',
          content: const Text(
            'Are you sure you want to delete this prediction?',
            style: TextStyle(fontSize: 15),
          ),
          cancelButtonText: 'Cancel',
          confirmButtonText: 'Delete',
          onCancel: () => Navigator.of(context).pop(),
          onConfirm: () async {
            setLoading(true);

            try {
              DeletePredictionRequest request = DeletePredictionRequest(
                  predictionId: prediction.predictionId!);
              var response = await PredictionApi.deletePrediction(request);

              if (response.isSuccess == true && context.mounted) {
                deletePrediction(prediction.predictionId!);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              }
            } catch (e) {
              if (context.mounted) {
                SnackbarManager.showErrorSnackBar(
                    context, "Failed to delete prediction");
              }
            }
            setLoading(false);
          },
        );
      },
    );
  }

  static Widget buildKeyValuePair(String key, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Text(
            "$key: ",
            style: GoogleFonts.roboto(
              fontSize: 16.0,
              color: Colors.black,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.roboto(
              fontSize: 16.0,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  static Color getStatusColor(String status) {
    switch (status) {
      case "processed":
        return Colors.green;
      case "failed":
        return Colors.red;
      case "pending":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  static String formatDiagnosisType(String? type) {
    if (type == null) return 'N/A';
    return type.replaceAll('_', ' ').toUpperCase();
  }

  static Color getDiagnosisColor(String? type) {
    switch (type) {
      case 'cancer':
        return Colors.red;
      case 'not_cancer':
        return Colors.green;
      case 'potentially_cancer':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
