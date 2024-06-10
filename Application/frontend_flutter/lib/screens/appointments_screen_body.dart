import 'package:flutter/material.dart';
import 'package:frontend_flutter/data_providers/appointments_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend_flutter/api/models/requests/appointment_requests/create_appointment_request.dart';
import 'package:frontend_flutter/app/snackbar_manager.dart';
import 'package:intl/intl.dart';
import 'appointment_detail_screen.dart';

class AppointmentsScreenBody extends StatefulWidget {
  @override
  _AppointmentsScreenBodyState createState() => _AppointmentsScreenBodyState();
}

class _AppointmentsScreenBodyState extends State<AppointmentsScreenBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppointmentsProvider>(context, listen: false).fetchAppointments();
    });
  }

  Future<void> _createAppointment(BuildContext context) async {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController institutionNameController = TextEditingController();
    TextEditingController addressController = TextEditingController();
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create Appointment'),
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
                              : DateFormat.yMd().format(selectedDate!)),
                        ),
                        IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () async {
                            final DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
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
                              initialTime: TimeOfDay.now(),
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

                  CreateAppointmentRequest request = CreateAppointmentRequest(
                    title: titleController.text,
                    description: descriptionController.text,
                    appointmentDate: appointmentDate,
                    institutionName: institutionNameController.text,
                    address: addressController.text,
                  );

                  await Provider.of<AppointmentsProvider>(context, listen: false).createAppointment(request);

                  Navigator.of(context).pop();
                } else {
                  SnackbarManager.showErrorSnackBar(context, 'Please fill all fields and select date and time');
                }
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _createAppointment(context),
          ),
        ],
      ),
      body: Consumer<AppointmentsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (provider.appointments.isEmpty) {
            return Center(child: Text('No results'));
          }
          return ListView.builder(
            itemCount: provider.appointments.length,
            itemBuilder: (context, index) {
              var appointment = provider.appointments[index];
              return ListTile(
                title: Text(appointment.title ?? 'No Title'),
                subtitle: Text(DateFormat.yMd().add_jm().format(appointment.appointmentDate)),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AppointmentDetailScreen(appointmentId: appointment.id!),
                )),
              );
            },
          );
        },
      ),
    );
  }
}
