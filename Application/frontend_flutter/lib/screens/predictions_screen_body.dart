import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_flutter/data_providers/predictions_provider.dart';

class PredictionsScreenBody extends StatefulWidget {
  @override
  _PredictionsScreenState createState() => _PredictionsScreenState();
}

class _PredictionsScreenState extends State<PredictionsScreenBody> {
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
        title: Text("My Predictions"),
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
          IconButton(icon: Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      body: Consumer<PredictionsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (provider.predictions.isEmpty) {
            return Center(child: Text("No results found"));
          }
          return GridView.builder(
            padding: EdgeInsets.all(8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: provider.predictions.length,
            itemBuilder: (context, index) {
              final prediction = provider.predictions[index];
              return GestureDetector(
                onTap: () {
                  // Navigate to details page with prediction
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
                          Text(prediction.title ?? "Unknown", style: TextStyle(color: Colors.white)),
                          Text(prediction.diagnosisName ?? "Unknown", style: TextStyle(color: Colors.white)),
                          //Text(prediction.date ?? "Date not provided", style: TextStyle(color: Colors.white)),
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
        },
      ),
    );
  }
}
