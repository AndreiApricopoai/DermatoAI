class GetAppointmentRequest {
  final String appointmentId;

  GetAppointmentRequest({
    required this.appointmentId,
  });

  String getUrl(String baseUrl) {
    return '$baseUrl/$appointmentId';
  }
}