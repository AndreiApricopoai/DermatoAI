import 'package:flutter/material.dart';
import 'package:frontend_flutter/app/app_main_theme.dart';
import 'package:frontend_flutter/data_providers/infromation_page_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class InformationScreenBody extends StatelessWidget {
  const InformationScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65.0,
        backgroundColor: AppMainTheme.blueLevelFive,
        title: Text(
          'Information',
          style: GoogleFonts.roboto(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: diseases.length,
        itemBuilder: (context, index) {
          final disease = diseases[index];
          final color = getColor(disease.name);

          return Card(
            color: color,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    disease.name,
                    style: GoogleFonts.roboto(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppMainTheme.black,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  buildInfoText('Description', disease.description),
                  const SizedBox(height: 8.0),
                  buildInfoText('Origin', disease.origin),
                  const SizedBox(height: 8.0),
                  buildInfoText('Severity', disease.severity),
                  const SizedBox(height: 8.0),
                  buildInfoText('Treatment', disease.treatment),
                  const SizedBox(height: 8.0),
                  buildInfoText(
                      'Lifestyle Upgrades', disease.lifestyleUpgrades),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildInfoText(String title, String content) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$title: ',
            style: GoogleFonts.roboto(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: content,
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Color getColor(String name) {
    switch (name.toLowerCase()) {
      case 'vascular lesion':
      case 'actinic keratosis':
      case 'nevus (mole)':
        return Colors.yellow.withOpacity(0.3);
      case 'squamous cell carcinoma':
      case 'melanoma':
      case 'basal cell carcinoma':
        return Colors.red.withOpacity(0.3);
      default:
        return Colors.green.withOpacity(0.3);
    }
  }
}
