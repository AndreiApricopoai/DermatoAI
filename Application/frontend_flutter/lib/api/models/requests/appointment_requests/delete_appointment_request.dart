class DeleteAppointmentRequest {
  final String appointmentId;

  DeleteAppointmentRequest({
    required this.appointmentId,
  });

  String getUrl(String baseUrl) {
    return '$baseUrl/$appointmentId';
  }
}
