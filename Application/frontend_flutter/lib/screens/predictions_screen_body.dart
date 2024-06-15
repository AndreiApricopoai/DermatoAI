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
  const PredictionsScreenBody({super.key});

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
                    : const TextTitle(
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
                  : const SizedBox.shrink();
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
      style: const TextStyle(color: Colors.white, fontSize: 16.0),
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
            prediction.title
                ?.toLowerCase()
                .contains(searchQuery.toLowerCase()) ??
            false)
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
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.75,
      ),
      itemCount: filteredPredictions.length,
      itemBuilder: (context, index) {
        final prediction =
            filteredPredictions[filteredPredictions.length - 1 - index];
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
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              prediction.imageUrl ?? '',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prediction.title ?? "Title not provided",
                    style: GoogleFonts.roboto(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (prediction.diagnosisName != null)
                    Text(
                      prediction.diagnosisName ?? "",
                      style: GoogleFonts.roboto(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: getDiagnosisColor(prediction.diagnosisName!),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (prediction.diagnosisName != null)
                    const SizedBox(height: 4),
                  Text(
                    prediction.createdAt ?? "Date not provided",
                    style: GoogleFonts.roboto(
                      fontSize: 11.0,
                      color: Colors.grey[300],
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    prediction.status!,
                    style: GoogleFonts.roboto(
                      fontSize: 11.0,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(prediction.status),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case "failed":
        return Colors.red;
      case "pending":
        return Colors.yellow;
      case "processed":
        return Colors.green;
      default:
        return Colors.white;
    }
  }

  Color getDiagnosisColor(String diagnosisName) {
    switch (diagnosisName.toLowerCase()) {
      case "actinic keratosis":
      case "nevus":
      case "vascular lesion":
        return Colors.orange;
      case "basal cell carcinoma":
      case "melanoma":
      case "squamous cell carcinoma":
        return Colors.red;
      case "dermatofibroma":
      case "pigmented benign keratosis":
        return Colors.yellow;
      case "healthy":
        return Colors.green;
      default:
        return Colors.grey.shade300;
    }
  }
}
