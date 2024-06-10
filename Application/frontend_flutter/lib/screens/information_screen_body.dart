import 'package:flutter/material.dart';
import 'package:frontend_flutter/data_providers/infromation_page_provider.dart';

class InformationScreenBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Information'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: diseases.length,
        itemBuilder: (context, index) {
          final disease = diseases[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    disease.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text('Description: ${disease.description}'),
                  SizedBox(height: 8.0),
                  Text('Origin: ${disease.origin}'),
                  SizedBox(height: 8.0),
                  Text('Severity: ${disease.severity}'),
                  SizedBox(height: 8.0),
                  Text('Treatment: ${disease.treatment}'),
                  SizedBox(height: 8.0),
                  Text('Lifestyle Upgrades: ${disease.lifestyleUpgrades}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
