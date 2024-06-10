import 'package:flutter/material.dart';
import 'package:frontend_flutter/data_providers/appointments_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend_flutter/api/models/requests/appointment_requests/patch_appointment_request.dart';
import 'package:intl/intl.dart';
import 'package:frontend_flutter/app/snackbar_manager.dart';

class AppointmentDetailScreen extends StatelessWidget {
  final String appointmentId;

  AppointmentDetailScreen({required this.appointmentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => _showEditDialog(context),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(context),
          ),
        ],
      ),
      body: Consumer<AppointmentsProvider>(
        builder: (context, provider, child) {
          // Find the appointment by id
          var appointmentIndex = provider.appointments.indexWhere((appointment) => appointment.id == appointmentId);
          
          // If the appointment is not found, show a message and pop the screen
          if (appointmentIndex == -1) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pop();
            });
            return Center(child: CircularProgressIndicator());
          }

          var appointment = provider.appointments[appointmentIndex];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Title: ${appointment.title}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('Description: ${appointment.description}', style: TextStyle(fontSize: 16)),
                SizedBox(height: 8),
                Text('Date: ${DateFormat.yMd().add_jm().format(appointment.appointmentDate)}', style: TextStyle(fontSize: 16)),
                SizedBox(height: 8),
                Text('Institution: ${appointment.institutionName}', style: TextStyle(fontSize: 16)),
                SizedBox(height: 8),
                Text('Address: ${appointment.address}', style: TextStyle(fontSize: 16)),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final provider = Provider.of<AppointmentsProvider>(context, listen: false);
    var appointmentIndex = provider.appointments.indexWhere((appointment) => appointment.id == appointmentId);

    if (appointmentIndex == -1) {
      SnackbarManager.showErrorSnackBar(context, 'Appointment not found');
      return;
    }

    var appointment = provider.appointments[appointmentIndex];

    TextEditingController titleController = TextEditingController(text: appointment.title);
    TextEditingController descriptionController = TextEditingController(text: appointment.description);
    TextEditingController institutionNameController = TextEditingController(text: appointment.institutionName);
    TextEditingController addressController = TextEditingController(text: appointment.address);
    DateTime? selectedDate = appointment.appointmentDate;
    TimeOfDay? selectedTime = TimeOfDay.fromDateTime(appointment.appointmentDate);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Appointment'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(labelText: 'Title'),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(labelText: 'Description'),
                    ),
                    TextField(
                      controller: institutionNameController,
                      decoration: InputDecoration(labelText: 'Institution Name'),
                    ),
                    TextField(
                      controller: addressController,
                      decoration: InputDecoration(labelText: 'Address'),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(selectedDate == null
                              ? 'Select Date'
                              : DateFormat.yMd().format(selectedDate ?? DateTime.now())),
                        ),
                        IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () async {
                            final DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: selectedDate ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                selectedDate = pickedDate;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(selectedTime == null
                              ? 'Select Time'
                              : selectedTime!.format(context)),
                        ),
                        IconButton(
                          icon: Icon(Icons.access_time),
                          onPressed: () async {
                            final TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: selectedTime ?? TimeOfDay.now(),
                            );
                            if (pickedTime != null) {
                              setState(() {
                                selectedTime = pickedTime;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (titleController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty &&
                    selectedDate != null &&
                    selectedTime != null) {
                  DateTime appointmentDate = DateTime(
                    selectedDate!.year,
                    selectedDate!.month,
                    selectedDate!.day,
                    selectedTime!.hour,
                    selectedTime!.minute,
                  );

                  PatchAppointmentRequest request = PatchAppointmentRequest(
                    appointmentId: appointmentId,
                    title: titleController.text,
                    description: descriptionController.text,
                    appointmentDate: appointmentDate,
                    institutionName: institutionNameController.text,
                    address: addressController.text,
                  );

                  await provider.updateAppointment(request);

                  Navigator.of(context).pop();
                } else {
                  SnackbarManager.showErrorSnackBar(context, 'Please fill all fields and select date and time');
                }
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this appointment?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await Provider.of<AppointmentsProvider>(context, listen: false).deleteAppointment(appointmentId);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
