class ValidationError {
  final String message;
  final String path;

  ValidationError({required this.message, required this.path});

  factory ValidationError.fromJson(Map<String, dynamic> json) {
    return ValidationError(
      message: json['message'],
      path: json['path'],
    );
  }
}
