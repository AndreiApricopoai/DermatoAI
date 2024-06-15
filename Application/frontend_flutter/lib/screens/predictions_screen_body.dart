import 'package:flutter/material.dart';
import 'package:frontend_flutter/api/models/responses/prediction_responses/prediction_response.dart';
import 'package:frontend_flutter/screens/prediction_details_screen.dart';
import 'package:frontend_flutter/app/app_main_theme.dart';
import 'package:frontend_flutter/widgets/loading_overlay.dart';
import 'package:frontend_flutter/widgets/text_title.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:frontend_flutter/data_providers/predictions_provider.dart';

class PredictionsScreenBody extends StatefulWidget {
  @override
  _PredictionsScreenState createState() => _PredictionsScreenState();
}

class _PredictionsScreenState extends State<PredictionsScreenBody> {
  String searchQuery = "";
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<PredictionsProvider>(context, listen: false);
      if (provider.predictions.isEmpty) {
        provider.fetchPredictions();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              AppBar(
                toolbarHeight: 65.0,
                backgroundColor: AppMainTheme.blueLevelFive,
                title: isSearching
                    ? buildSearchField()
                    : TextTitle(
                        color: Colors.white,
                        text: 'Predictions',
                        fontSize: 24.0,
                        fontFamily: GoogleFonts.roboto,
                        fontWeight: FontWeight.w400,
                      ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: isSearching
                        ? IconButton(
                            icon: Icon(Icons.close, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                isSearching = false;
                                searchQuery = ''; // Clear search query
                              });
                            },
                          )
                        : IconButton(
                            icon: Icon(Icons.search, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                isSearching = true;
                              });
                            },
                          ),
                  ),
                ],
              ),
              Expanded(
                child: Consumer<PredictionsProvider>(
                  builder: (context, provider, child) {
                    return buildPredictionGrid(provider.predictions);
                  },
                ),
              ),
            ],
          ),
          Consumer<PredictionsProvider>(
            builder: (context, provider, child) {
              return provider.isLoading
                  ? LoadingOverlay(isLoading: provider.isLoading)
                  : SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget buildSearchField() {
    return TextField(
      autofocus: true,
      decoration: InputDecoration(
        hintText: "Enter prediction title",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
      ),
      style: TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (value) {
        setState(() {
          searchQuery = value;
        });
      },
    );
  }

  Widget buildPredictionGrid(List<Prediction> predictions) {
    List<Prediction> filteredPredictions = predictions
        .where((prediction) =>
            prediction.title?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false)
        .toList();

    if (filteredPredictions.isEmpty) {
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
              'No predictions found.',
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
    return GridView.builder(
      padding: EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: filteredPredictions.length,
      itemBuilder: (context, index) {
        final prediction = filteredPredictions[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      PredictionDetailScreen(prediction: prediction)),
            );
          },
          child: buildPredictionCard(prediction),
        );
      },
    );
  }

  Widget buildPredictionCard(Prediction prediction) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.network(
              prediction.imageUrl ?? '',
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) => Center(
                child: Icon(Icons.broken_image),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prediction.title ?? "Unknown",
                  style: GoogleFonts.roboto(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: AppMainTheme.blueLevelFive,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                if (prediction.diagnosisName != null)
                  Text(
                    prediction.diagnosisName!,
                    style: GoogleFonts.roboto(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: getDiagnosisColor(prediction.diagnosisName!),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                SizedBox(height: 4),
                Text(
                  prediction.createdAt ?? "Date not provided",
                  style: GoogleFonts.roboto(
                    fontSize: 12.0,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Status: ${prediction.status}",
                  style: GoogleFonts.roboto(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(prediction.status),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case "failed":
        return Colors.red;
      case "pending":
        return Colors.yellow;
      case "processed":
        return Colors.green;
      default:
        return Colors.white; // Default color for unknown status
    }
  }

  Color getDiagnosisColor(String diagnosisName) {
    switch (diagnosisName.toLowerCase()) {
      case "actinic keratosis":
        return Colors.orange;
      case "basal cell carcinoma":
      case "melanoma":
      case "squamous cell carcinoma":
        return Colors.red;
      case "dermatofibroma":
      case "pigmented benign keratosis":
      case "nevus":
        return Colors.green;
      case "vascular lesion":
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
