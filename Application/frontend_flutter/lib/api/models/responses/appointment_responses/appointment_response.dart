import 'package:frontend_flutter/api/models/responses/base_response.dart';

class AppointmentResponse extends BaseApiResponse {
  final String? id;
  final String? title;
  final String? description;
  final DateTime? appointmentDate;
  final String? institutionName;
  final String? address;

  AppointmentResponse.fromJson(super.json)
      : id = json['data']?['id'],
        title = json['data']?['title'],
        description = json['data']?['description'],
        appointmentDate = json['data']?['appointmentDate'],
        institutionName = json['data']?['institutionName'],
        address = json['data']?['address'],
        super.fromJson();

  AppointmentResponse.fromJsonElement(super.json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        appointmentDate = json['appointmentDate'],
        institutionName = json['institutionName'],
        address = json['address'],
        super.fromJson();
}
