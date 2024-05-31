import 'package:frontend_flutter/api/models/responses/validation_error.dart';

class BaseApiResponse {
  final bool isSuccess;
  final int apiResponseCode;
  final String? message;
  final String? error;
  final List<ValidationError>? validationErrors;

  BaseApiResponse({
    required this.isSuccess,
    required this.apiResponseCode,
    this.message,
    this.error,
    this.validationErrors,
  });

  BaseApiResponse.fromJson(Map<String, dynamic> json)
      : isSuccess = json['isSuccess'],
        apiResponseCode = json['apiResponseCode'],
        message = json['message'],
        error = json['error'],
        validationErrors = json['errors'] != null
            ? List<ValidationError>.from(json['errors'].map(
                (validationError) => ValidationError.fromJson(validationError)))
            : null;

  String getValidationErrorsFormatted() {
    if (validationErrors == null || validationErrors!.isEmpty) {
      return '';
    }
    return validationErrors!
        .map((validationError) => validationError.message)
        .join('\n');
  }

  String gerErrorMessage() {
    if (error != null && error!.isNotEmpty) {
      return error!;
    }
    return '';
  }
}
