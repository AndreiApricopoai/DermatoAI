import 'package:intl/intl.dart';

class Prediction {
  final String? predictionId;
  final String? userId;
  final String? title;
  final String? description;
  final String? imageUrl;
  final bool? isHealthy;
  final String? diagnosisName;
  final int? diagnosisCode;
  final String? diagnosisType;
  final double? confidenceLevel;
  final String? status;
  final String? createdAt;

  Prediction(
      {this.predictionId,
      this.userId,
      this.title,
      this.description,
      this.imageUrl,
      this.isHealthy,
      this.diagnosisName,
      this.diagnosisCode,
      this.diagnosisType,
      this.confidenceLevel,
      this.status,
      this.createdAt});

  Prediction.fromJson(Map<String, dynamic> json)
      : predictionId = json['id'],
        userId = json['userId'],
        title = json['title'],
        description = json['description'],
        imageUrl = json['imageUrl'],
        isHealthy = json['isHealthy'],
        diagnosisName = json['diagnosisName'],
        diagnosisCode = json['diagnosisCode'],
        diagnosisType = json['diagnosisType'],
        confidenceLevel = json['confidenceLevel'],
        status = json['status'],
        createdAt = formatDate(json['createdAt']);

  static String? formatDate(String? isoDate) {
    if (isoDate == null) return null;
    DateTime date = DateTime.parse(isoDate);
    return DateFormat('dd-MM-yyyy').format(date);
  }
}
