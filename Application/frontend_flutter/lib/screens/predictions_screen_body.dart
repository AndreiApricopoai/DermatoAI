import 'package:flutter/material.dart';
import 'package:frontend_flutter/api/models/responses/prediction_responses/prediction_response.dart';
import 'package:frontend_flutter/screens/prediction_details_screen.dart';
import 'package:frontend_flutter/app/app_main_theme.dart';
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
      appBar: AppBar(
        toolbarHeight: 65.0,
        backgroundColor: AppMainTheme.blueLevelFive,
        title: isSearching
            ? buildSearchField()
            : TextTitle(color: Colors.white, text: 'Predictions', fontSize: 24.0, fontFamily: GoogleFonts.roboto, fontWeight: FontWeight.w400,),
        actions: [
          isSearching
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
        ],
      ),
      body: Consumer<PredictionsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return buildPredictionGrid(provider.predictions);
        },
      ),
    );
  }

  Widget buildSearchField() {
    return TextField(
      autofocus: true,
      decoration: InputDecoration(
        hintText: "Enter prediction title",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
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
      return Center(child: Text("No results found"));
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
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: GridTile(
              footer: Container(
                padding: EdgeInsets.all(8),
                color: Colors.black54,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(prediction.title ?? "Unknown",
                        style: TextStyle(color: Colors.white)),
                    Text(prediction.diagnosisName ?? "Unknown",
                        style: TextStyle(color: Colors.white)),
                    Text(prediction.createdAt ?? "Date not provided",
                        style: TextStyle(color: Colors.white)),
                    SizedBox(height: 4),
                    Text(
                      "Status: ${prediction.status}",
                      style: TextStyle(
                          color: _getStatusColor(prediction.status),
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              child: Image.network(
                prediction.imageUrl ?? '',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Center(
                  child: Icon(Icons.broken_image),
                ),
              ),
            ),
          ),
        );
      },
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
}