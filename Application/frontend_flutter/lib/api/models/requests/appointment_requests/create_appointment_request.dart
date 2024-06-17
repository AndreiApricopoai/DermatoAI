import 'dart:convert';

class CreateAppointmentRequest {
  final String title;
  final DateTime appointmentDate;
  final String? description;
  final String? institutionName;
  final String? address;

  CreateAppointmentRequest({
    required this.title,
    required this.appointmentDate,
    this.description,
    this.institutionName,
    this.address,
  });

  String toJson() {
    final Map<String, dynamic> data = {
      'title': title,
      'appointmentDate': appointmentDate.toIso8601String(),
    };

    if (description != null && description!.isNotEmpty) {
      data['description'] = description;
    }
    if (institutionName != null && institutionName!.isNotEmpty) {
      data['institutionName'] = institutionName;
    }
    if (address != null && address!.isNotEmpty) {
      data['address'] = address;
    }

    return json.encode(data);
  }
}
