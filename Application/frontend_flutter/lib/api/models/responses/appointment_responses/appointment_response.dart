import 'package:frontend_flutter/api/models/responses/appointment_responses/appointment.dart';
import 'package:frontend_flutter/api/models/responses/base_response.dart';

class AppointmentResponse extends BaseApiResponse {
  final String? id;
  final String? title;
  final String? description;
  final DateTime appointmentDate;
  final String? institutionName;
  final String? address;

  AppointmentResponse.fromJson(super.json)
      : id = json['data']?['id'],
        title = json['data']?['title'],
        description = json['data']?['description'],
        appointmentDate = json['data']['appointmentDate'] != null ? DateTime.parse(json['data']['appointmentDate']) : DateTime.now(),
        institutionName = json['data']?['institutionName'],
        address = json['data']?['address'],
        super.fromJson();
  
  Appointment toAppointment() {
    return Appointment(
      id: id,
      title: title,
      description: description,
      appointmentDate: appointmentDate,
      institutionName: institutionName,
      address: address,
    );
  }
}
