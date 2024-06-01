import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend_flutter/api/api_calls/prediction_api.dart';
import 'package:frontend_flutter/api/models/requests/prediction_requests/delete_prediction_request.dart';
import 'package:frontend_flutter/api/models/requests/prediction_requests/patch_prediction_request.dart';
import 'package:frontend_flutter/api/models/responses/prediction_responses/prediction_response.dart';
import 'package:frontend_flutter/data_providers/predictions_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PredictionDetailScreen extends StatefulWidget {
  final Prediction prediction;
  bool _isLoading = false;

  PredictionDetailScreen({required this.prediction});

  @override
  _PredictionDetailScreenState createState() => _PredictionDetailScreenState();
}

class _PredictionDetailScreenState extends State<PredictionDetailScreen> {
  late Prediction prediction;

  @override
  void initState() {
    super.initState();
    prediction = widget.prediction;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> content = [
      Text("Title: ${prediction.title}"),
      if (prediction.description != null)
        Text("Description: ${prediction.description}"),
      Text("Created On: ${prediction.createdAt}"),
      Image.network(prediction.imageUrl ?? '', fit: BoxFit.cover),
    ];
    if (prediction.status == "pending") {
      content.add(Text("Status: ${prediction.status}",
          style: TextStyle(color: Colors.orange)));
    } else if (prediction.status == "processed") {
      content.addAll([
        Text("Diagnosis: ${prediction.diagnosisName}"),
        Text("Diagnosis Code: ${prediction.diagnosisCode}"),
        Text("Diagnosis Type: ${prediction.diagnosisType}"),
        Text("Confidence Level: ${prediction.confidenceLevel}%"),
        Text("Status: ${prediction.status}",
            style: TextStyle(color: Colors.green)),
      ]);
      if (prediction.isHealthy == true) {
        content.add(Text("Healthy", style: TextStyle(color: Colors.green)));
      } else if (prediction.isHealthy == false) {
        content.add(Text("Unhealthy", style: TextStyle(color: Colors.red)));
      } else {
        content.add(Text("Unknown", style: TextStyle(color: Colors.grey)));
      }
    } else if (prediction.status == "failed") {
      content.add(Text("Status: ${prediction.status}",
          style: TextStyle(color: Colors.red)));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(prediction.title ?? "Prediction Detail"),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => _showEditDialog(context),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: content,
        ),
      ),
    );
  }

  void _showLoadingDialog(bool show) {
    if (show) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 20),
                  Text("Processing..."),
                ],
              ),
            ),
          );
        },
      );
    } else {
      Navigator.of(context, rootNavigator: true).pop('dialog');
    }
  }

  void _showEditDialog(BuildContext context) {
    TextEditingController titleController =
        TextEditingController(text: prediction.title);
    TextEditingController descriptionController =
        TextEditingController(text: prediction.description);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Prediction'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () async {
                _showLoadingDialog(true); // Show loading dialog
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
                    setState(() {
                      prediction =
                          updatedPrediction; // Update local state to refresh UI
                    });
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        Text("Failed to update prediction: ${e.toString()}"),
                  ));
                }
                _showLoadingDialog(false); // Hide loading dialog
                Navigator.of(context).pop(); // Close dialog
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
          content: Text('Are you sure you want to delete this prediction?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                _showLoadingDialog(true); // Show loading dialog
                try {
                  DeletePredictionRequest request = DeletePredictionRequest(
                      predictionId: prediction.predictionId!);
                  var response = await PredictionApi.deletePrediction(request);

                  if (response.isSuccess == true && context.mounted) {
                    Provider.of<PredictionsProvider>(context, listen: false)
                        .deletePrediction(prediction.predictionId!);
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.of(context).pop(); // Go back to list
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        Text("Failed to delete prediction: ${e.toString()}"),
                  ));
                }
                _showLoadingDialog(false); // Hide loading dialog
              },
            ),
          ],
        );
      },
    );
  }
}
