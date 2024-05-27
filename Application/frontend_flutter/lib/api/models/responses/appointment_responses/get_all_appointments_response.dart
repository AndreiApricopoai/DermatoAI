import 'package:frontend_flutter/api/models/responses/appointment_responses/appointment_response.dart';
import 'package:frontend_flutter/api/models/responses/base_response.dart';

class GetAllAppointmentsResponse extends BaseApiResponse {
  final List<AppointmentResponse> appointments;

  GetAllAppointmentsResponse.fromJson(super.json)
      : appointments = (json['data'] as List)
            .map((appointment) => AppointmentResponse.fromJsonElement(appointment))
            .toList(),
        super.fromJson();
}
