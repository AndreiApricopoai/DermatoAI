import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_flutter/app/notifications_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend_flutter/api/api_calls/appointment_api.dart';
import 'package:frontend_flutter/api/models/requests/appointment_requests/create_appointment_request.dart';
import 'package:frontend_flutter/api/models/requests/appointment_requests/delete_appointment_request.dart';
import 'package:frontend_flutter/api/models/requests/appointment_requests/patch_appointment_request.dart';
import 'package:frontend_flutter/api/models/responses/appointment_responses/appointment.dart';
import 'package:permission_handler/permission_handler.dart';

class AppointmentsProvider with ChangeNotifier {
  List<Appointment> _appointments = [];
  bool _isLoading = false;

  List<Appointment> get appointments => _appointments;
  bool get isLoading => _isLoading;

  AppointmentsProvider() {
    _loadAppointments();
  }

  Future<void> _requestExactAlarmPermission() async {
    if (await Permission.scheduleExactAlarm.request().isGranted) {
      print("Exact alarm permission granted");
    } else {
      print("Exact alarm permission denied");
    }
  }

  Future<void> _loadAppointments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? appointmentsData = prefs.getString('appointments');
    if (appointmentsData != null) {
      List<dynamic> decodedData = jsonDecode(appointmentsData);
      _appointments = decodedData.map((e) => Appointment.fromJson(e)).toList();
    }
    notifyListeners();
  }

  Future<void> _saveAppointments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedData = jsonEncode(_appointments.map((e) => e.toJson()).toList());
    prefs.setString('appointments', encodedData);
  }

Future<void> _scheduleNotification(Appointment appointment) async {
  // Get the current date in UTC
  DateTime now = DateTime.now().toUtc();
  // Ensure the appointment date is in UTC
  DateTime appointmentDate = appointment.appointmentDate!.toUtc();
  appointmentDate = appointmentDate.subtract(Duration(hours: 3));

  // Print current date
  print("Current date is: ");
  print(now);

  // Print appointment date
  print("Appointment date is: ");
  print(appointmentDate);

  // Calculate the difference
  Duration difference = appointmentDate.difference(now);
  print("diferenta este de ");
  print(difference);

  if (difference.inDays >= 1) {
    await NotificationsHelper.setNotification(
      appointmentDate.subtract(Duration(hours: 24)),
      appointment.id.hashCode + 10,
      'Appointment Reminder',
      'Your appointment is in 24 hours.',
    );
    await NotificationsHelper.setNotification(
      appointmentDate.subtract(Duration(hours: 12)),
      appointment.id.hashCode + 1,
      'Appointment Reminder',
      'Your appointment is in 12 hours.',
    );
    await NotificationsHelper.setNotification(
      appointmentDate.subtract(Duration(hours: 6)),
      appointment.id.hashCode + 2,
      'Appointment Reminder',
      'Your appointment is in 6 hours.',
    );
  } else if (difference.inHours >= 1) {
    int halfDifferenceInHours = (difference.inHours / 2).round();
    DateTime halfDifferenceTime = now.add(Duration(hours: halfDifferenceInHours));
    await NotificationsHelper.setNotification(
      halfDifferenceTime,
      appointment.id.hashCode + 3,
      'Appointment Reminder',
      'Your appointment is soon.',
    );
  }
}

  Future<void> fetchAppointments() async {
    _isLoading = true;
    notifyListeners();
    try {
      var response = await AppointmentApi.getAllAppointments();
      if (response.isSuccess) {
        _appointments = response.appointments;
        _saveAppointments();
        for (var appointment in _appointments) {
          _scheduleNotification(appointment);
        }
      } else {
        throw Exception('Failed to fetch appointments');
      }
    } catch (e) {
      print('Error fetching appointments: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createAppointment(CreateAppointmentRequest request) async {
    _isLoading = true;
    notifyListeners();
    try {
      print("Creating appointment with date: ${request.appointmentDate}");
      var response = await AppointmentApi.createAppointment(request);
      if (response.isSuccess) {
        var newAppointment = response.toAppointment();
        _appointments.add(newAppointment);
        _saveAppointments();
        _scheduleNotification(newAppointment);
        // await NotificationsHelper.setNotification(
        //   DateTime.now().add(Duration(seconds: 10)),
        //   newAppointment.id.hashCode,
        //   'Appointment Created',
        //   'Your appointment has been created.',
        // );
        notifyListeners();
      } else {
        throw Exception('Failed to create appointment');
      }
    } catch (e) {
      print('Error creating appointment: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteAppointment(String appointmentId) async {
    _isLoading = true;
    notifyListeners();
    try {
      var request = DeleteAppointmentRequest(appointmentId: appointmentId);
      var response = await AppointmentApi.deleteAppointment(request);
      if (response.isSuccess) {
        _appointments.removeWhere((appointment) => appointment.id == appointmentId);
        _saveAppointments();
        notifyListeners();
      } else {
        throw Exception('Failed to delete appointment');
      }
    } catch (e) {
      print('Error deleting appointment: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateAppointment(PatchAppointmentRequest request) async {
    _isLoading = true;
    notifyListeners();
    try {
      var response = await AppointmentApi.patchAppointment(request);
      if (response.isSuccess) {
        int index = _appointments.indexWhere((appointment) => appointment.id == request.appointmentId);
        if (index != -1) {
          var updatedAppointment = response.toAppointment();
          _appointments[index] = updatedAppointment;
          _saveAppointments();
          _scheduleNotification(updatedAppointment);
          notifyListeners();
        }
      } else {
        throw Exception('Failed to update appointment');
      }
    } catch (e) {
      print('Error updating appointment: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
