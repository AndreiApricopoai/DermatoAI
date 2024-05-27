import 'dart:convert';

class CreateAppointmentRequest {
  final String title;
  final String description;
  final DateTime appointmentDate;
  final String institutionName;
  final String address;

  CreateAppointmentRequest({
    required this.title,
    required this.description,
    required this.appointmentDate,
    required this.institutionName,
    required this.address,
  });

  String toJson() {
    return json.encode({
      'title': title,
      'description': description,
      'appointmentDate': appointmentDate.toIso8601String(),
      'institutionName': institutionName,
      'address': address,
    });
  }
}
