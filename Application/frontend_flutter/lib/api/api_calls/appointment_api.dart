import 'package:frontend_flutter/api/models/requests/appointment_requests/create_appointment_request.dart';
import 'package:frontend_flutter/api/models/requests/appointment_requests/delete_appointment_request.dart';
import 'package:frontend_flutter/api/models/requests/appointment_requests/get_appointment_request.dart';
import 'package:frontend_flutter/api/models/requests/appointment_requests/patch_appointment_request.dart';
import 'package:frontend_flutter/api/models/responses/appointment_responses/appointment_response.dart';
import 'package:frontend_flutter/api/models/responses/appointment_responses/get_all_appointments_response.dart';
import 'package:frontend_flutter/api/models/responses/base_response.dart';
import 'package:http/http.dart' as http;
import 'package:frontend_flutter/api/api_calls/base_api.dart';
import 'dart:convert';
import 'dart:io';

class AppointmentApi {
  static Future<AppointmentResponse> getAppointment(
      GetAppointmentRequest getAppointmentRequest) async {
    try {
      request() async {
        final urlSuffix = getAppointmentRequest.getUrl('appointments');
        final url = BaseApi.getUri(urlSuffix);
        final headers = BaseApi.getHeadersWithAuthorization();
        return await http.get(url, headers: headers);
      }

      var response = await BaseApi.performRequestWithRetry(request);
      var jsonResponse = jsonDecode(response.body);
      AppointmentResponse appointmentResponse =
          AppointmentResponse.fromJson(jsonResponse);
      return appointmentResponse;
    } on SocketException {
      throw Exception(
          'Unable to connect to the server. Please check your internet connection');
    } on FormatException {
      throw Exception('Could not get appointment. Please try again later');
    } on Exception {
      throw Exception('Unexpected error occurred');
    }
  }

  static Future<GetAllAppointmentsResponse> getAllAppointments() async {
    try {
      request() async {
        final url = BaseApi.getUri('appointments');
        final headers = BaseApi.getHeadersWithAuthorization();
        return await http.get(url, headers: headers);
      }

      var response = await BaseApi.performRequestWithRetry(request);
      var jsonResponse = jsonDecode(response.body);
      GetAllAppointmentsResponse getAllAppointmentsResponse =
          GetAllAppointmentsResponse.fromJson(jsonResponse);
      return getAllAppointmentsResponse;
    } on SocketException {
      throw Exception(
          'Unable to connect to the server. Please check your internet connection');
    } on FormatException {
      throw Exception('Could not get appointments. Please try again later');
    } on Exception {
      throw Exception('Unexpected error occurred');
    }
  }

  static Future<AppointmentResponse> createAppointment(
      CreateAppointmentRequest createAppointmentRequest) async {
    try {
      request() async {
        final url = BaseApi.getUri('appointments');

        final body = createAppointmentRequest.toJson();

        final headers = BaseApi.getHeadersWithAuthorization();
        return await http.post(url, headers: headers, body: body);
      }

      var response = await BaseApi.performRequestWithRetry(request);
      var jsonResponse = jsonDecode(response.body);
      AppointmentResponse appointmentResponse =
          AppointmentResponse.fromJson(jsonResponse);
      return appointmentResponse;
    } on SocketException {
      throw Exception(
          'Unable to connect to the server. Please check your internet connection');
    } on FormatException {
      throw Exception('Could not create appointment. Please try again later');
    } on Exception {
      throw Exception('Unexpected error occurred');
    }
  }

  static Future<AppointmentResponse> patchAppointment(
      PatchAppointmentRequest patchAppointmentRequest) async {
    try {
      request() async {
        final urlSuffix = patchAppointmentRequest.getUrl('appointments');
        final url = BaseApi.getUri(urlSuffix);
        final body = patchAppointmentRequest.toJson();
        final headers = BaseApi.getHeadersWithAuthorization();
        return await http.patch(url, headers: headers, body: body);
      }

      var response = await BaseApi.performRequestWithRetry(request);
      var jsonResponse = jsonDecode(response.body);
      AppointmentResponse appointmentResponse =
          AppointmentResponse.fromJson(jsonResponse);
      return appointmentResponse;
    } on SocketException {
      throw Exception(
          'Unable to connect to the server. Please check your internet connection');
    } on FormatException {
      throw Exception('Could not update appointment. Please try again later');
    } on Exception {
      throw Exception('Unexpected error occurred');
    }
  }

  static Future<BaseApiResponse> deleteAppointment(
      DeleteAppointmentRequest deleteAppointmentRequest) async {
    try {
      request() async {
        final urlSuffix = deleteAppointmentRequest.getUrl('appointments');
        final url = BaseApi.getUri(urlSuffix);
        final headers = BaseApi.getHeadersWithAuthorization();
        return await http.delete(url, headers: headers);
      }

      var response = await BaseApi.performRequestWithRetry(request);
      var jsonResponse = jsonDecode(response.body);
      BaseApiResponse deleteAppointmentResponse =
          BaseApiResponse.fromJson(jsonResponse);
      return deleteAppointmentResponse;
    } on SocketException {
      throw Exception(
          'Unable to connect to the server. Please check your internet connection');
    } on FormatException {
      throw Exception('Could not delete appointment. Please try again later');
    } on Exception {
      throw Exception('Unexpected error occurred');
    }
  }
}
