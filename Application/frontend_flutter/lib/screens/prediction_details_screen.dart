import 'package:flutter/material.dart';
import 'package:frontend_flutter/api/models/responses/prediction_responses/prediction_response.dart';
import 'package:frontend_flutter/app/app_main_theme.dart';
import 'package:frontend_flutter/data_providers/predictions_provider.dart';
import 'package:frontend_flutter/widgets/button_outline_icon.dart';
import 'package:frontend_flutter/widgets/loading_overlay.dart';
import 'package:frontend_flutter/widgets/text_title.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:frontend_flutter/actions/predictions_actions.dart';

class PredictionDetailScreen extends StatefulWidget {
  final Prediction prediction;

  const PredictionDetailScreen({super.key, required this.prediction});

  @override
  _PredictionDetailScreenState createState() => _PredictionDetailScreenState();
}

class _PredictionDetailScreenState extends State<PredictionDetailScreen> {
  late Prediction prediction;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    prediction = widget.prediction;
  }

  void setLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  void updatePrediction(Prediction updatedPrediction) {
    setState(() {
      prediction = updatedPrediction;
    });
  }

  void deletePrediction(String predictionId) {
    Provider.of<PredictionsProvider>(context, listen: false)
        .deletePrediction(predictionId);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> content = [
      Center(
        child: Text(
          prediction.title ?? "No Title",
          style: GoogleFonts.lato(
            fontSize: 26.0,
            fontWeight: FontWeight.bold,
            color: AppMainTheme.blueLevelFive,
          ),
        ),
      ),
      const SizedBox(height: 20),
      if (prediction.description != null && prediction.description!.isNotEmpty)
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
              ),
            ],
          ),
          child: Text(
            prediction.description!,
            style: GoogleFonts.lato(
              fontSize: 16.0,
              color: Colors.grey[800],
            ),
          ),
        ),
      if (prediction.description != null && prediction.description!.isNotEmpty)
        const SizedBox(height: 20),
      Text(
        "Created on: ${prediction.createdAt}",
        style: GoogleFonts.lato(
          fontSize: 14.0,
          color: Colors.grey[600],
        ),
      ),
      const SizedBox(height: 20),
      ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Image.network(
          prediction.imageUrl ?? '',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Center(
            child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
          ),
        ),
      ),
      const SizedBox(height: 20),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (prediction.diagnosisName != null)
            PredictionActions.buildKeyValuePair(
              "Diagnosis",
              prediction.isHealthy == true
                  ? "Healthy"
                  : prediction.diagnosisName ?? 'N/A',
              prediction.isHealthy == true ? Colors.green : Colors.black,
            ),
          if (prediction.diagnosisName != null && prediction.isHealthy == false)
            const SizedBox(height: 10),
          if (prediction.isHealthy == false)
            PredictionActions.buildKeyValuePair(
              "Diagnosis Type",
              PredictionActions.formatDiagnosisType(prediction.diagnosisType),
              PredictionActions.getDiagnosisColor(prediction.diagnosisType),
            ),
          if (prediction.isHealthy == false ||
              prediction.confidenceLevel != null)
            const SizedBox(height: 10),
          if (prediction.confidenceLevel != null)
            PredictionActions.buildKeyValuePair(
              "Probability",
              "${(prediction.confidenceLevel! * 100).toStringAsFixed(2)}%",
              Colors.black,
            ),
          if (prediction.diagnosisName != null ||
              prediction.isHealthy == false ||
              prediction.confidenceLevel != null)
            const SizedBox(height: 10),
          PredictionActions.buildKeyValuePair(
            "Status",
            prediction.status!,
            PredictionActions.getStatusColor(prediction.status!),
          ),
        ]),
      ),
      const SizedBox(height: 30),
      if (prediction.status == 'processed' && prediction.isHealthy == false)
        Center(
          child: CustomOutlinedButton(
            backgroundColor: AppMainTheme.blueLevelFive,
            text: 'Ask DermatoAI',
            textColor: Colors.white,
            borderColor: AppMainTheme.blueLevelThree,
            pressColor: Colors.teal,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.lato,
            width: 240,
            height: 50,
            iconSize: 35,
            iconColor: Colors.white,
            elementsSpacing: 10,
            icon: const AssetImage('assets/icons/app_logo_white.png'),
            onPressed: () {
              // Navigate to the AI chat screen
            },
          ),
        ),
    ];

    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        toolbarHeight: 65.0,
        backgroundColor: AppMainTheme.blueLevelFive,
        title: const TextTitle(
          color: Colors.white,
          text: 'Details',
          fontSize: 21.0,
          fontFamily: GoogleFonts.roboto,
          fontWeight: FontWeight.w400,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () => PredictionActions.showEditDialog(
                context, prediction, setLoading, updatePrediction),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: () => PredictionActions.showDeleteDialog(
                  context, prediction, setLoading, deletePrediction),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.blueGrey[50],
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 80.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: content,
              ),
            ),
          ),
          if (_isLoading) LoadingOverlay(isLoading: _isLoading),
        ],
      ),
    );
  }
}
