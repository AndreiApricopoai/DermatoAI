import 'dart:convert';

class PatchAppointmentRequest {
  final String appointmentId;
  final String? title;
  final String? description;
  final DateTime? appointmentDate;
  final String? institutionName;
  final String? address;

  PatchAppointmentRequest({
    required this.appointmentId,
    this.title,
    this.description,
    this.appointmentDate,
    this.institutionName,
    this.address,
  });

  String toJson() {
    final Map<String, dynamic> data = {};
    if (title != null && title!.isNotEmpty) data['title'] = title;
    if (description != null && description!.isNotEmpty) data['description'] = description;
    if (appointmentDate != null) data['appointmentDate'] = appointmentDate?.toIso8601String();
    if (institutionName != null && institutionName!.isNotEmpty) data['institutionName'] = institutionName;
    if (address != null && address!.isNotEmpty) data['address'] = address;
    return json.encode(data);
  }

  String getUrl(String baseUrl) {
    return '$baseUrl/$appointmentId';
  }
}
