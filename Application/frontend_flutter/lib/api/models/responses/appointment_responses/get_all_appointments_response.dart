import 'package:frontend_flutter/api/models/responses/appointment_responses/appointment.dart';
import 'package:frontend_flutter/api/models/responses/base_response.dart';

class GetAllAppointmentsResponse extends BaseApiResponse {
  final List<Appointment> appointments;

  GetAllAppointmentsResponse.fromJson(super.json)
      : appointments = (json['data'] as List)
            .map((appointment) => Appointment.fromJson(appointment))
            .toList(),
        super.fromJson();
}
