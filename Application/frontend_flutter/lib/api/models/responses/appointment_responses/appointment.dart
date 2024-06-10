class Appointment {
  final String? id;
  final String? title;
  final String? description;
  final DateTime appointmentDate;
  final String? institutionName;
  final String? address;

  Appointment({
    this.id,
    this.title,
    this.description,
    required this.appointmentDate,
    this.institutionName,
    this.address,
  });

  Appointment.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        appointmentDate = json['appointmentDate'] != null ? DateTime.parse(json['appointmentDate']) : DateTime.now(),
        institutionName = json['institutionName'],
        address = json['address'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'appointmentDate': appointmentDate.toIso8601String(),
      'institutionName': institutionName,
      'address': address,
    };
  }
}
