import 'package:flutter/material.dart';
import 'package:frontend_flutter/api/models/responses/appointment_responses/appointment.dart';
import 'package:frontend_flutter/data_providers/appointments_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:frontend_flutter/app/app_main_theme.dart';
import 'package:frontend_flutter/widgets/text_title.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_flutter/widgets/custom_alert_dialog.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:frontend_flutter/widgets/loading_overlay.dart';
import 'package:frontend_flutter/validators/input_validators.dart';
import 'package:frontend_flutter/api/models/requests/appointment_requests/patch_appointment_request.dart';
import 'package:frontend_flutter/app/snackbar_manager.dart';

class AppointmentDetailScreen extends StatelessWidget {
  final String appointmentId;

  const AppointmentDetailScreen({super.key, required this.appointmentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65.0,
        backgroundColor: AppMainTheme.blueLevelFive,
        title: Consumer<AppointmentsProvider>(
          builder: (context, provider, child) {
            var appointment = provider.appointments.firstWhere(
              (appointment) => appointment.id == appointmentId,
              orElse: () => Appointment(
                  id: '',
                  title: '',
                  description: '',
                  appointmentDate: DateTime.now(),
                  institutionName: '',
                  address: ''),
            );

            return TextTitle(
              color: Colors.white,
              text: appointment.title ?? '',
              fontSize: 21.0,
              fontFamily: GoogleFonts.roboto,
              fontWeight: FontWeight.w400,
            );
          },
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () => _showEditDialog(context),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: () => _showDeleteDialog(context),
            ),
          ),
        ],
      ),
      body: Consumer<AppointmentsProvider>(
        builder: (context, provider, child) {
          var appointmentIndex = provider.appointments
              .indexWhere((appointment) => appointment.id == appointmentId);

          if (appointmentIndex == -1) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pop();
            });
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 7.0,
                color: AppMainTheme.blueLevelFive,
              ),
            );
          }

          var appointment = provider.appointments[appointmentIndex];

          return Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 35.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (appointment.title != null &&
                        appointment.title!.isNotEmpty)
                      _buildDetailRow('Title', appointment.title!),
                    if (appointment.description != null &&
                        appointment.description!.isNotEmpty)
                      _buildDetailRow('Description', appointment.description!),
                    _buildDetailRow(
                        'Date',
                        DateFormat.yMMMMd()
                            .add_jm()
                            .format(appointment.appointmentDate)),
                    if (appointment.institutionName != null &&
                        appointment.institutionName!.isNotEmpty)
                      _buildDetailRow(
                          'Institution', appointment.institutionName!),
                    if (appointment.address != null &&
                        appointment.address!.isNotEmpty)
                      _buildDetailRow('Address', appointment.address!),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: GoogleFonts.roboto(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppMainTheme.blueLevelFive,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: GoogleFonts.roboto(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final provider = Provider.of<AppointmentsProvider>(context, listen: false);
    var appointmentIndex = provider.appointments
        .indexWhere((appointment) => appointment.id == appointmentId);

    if (appointmentIndex == -1) {
      SnackbarManager.showErrorSnackBar(context, 'Appointment not found');
      return;
    }

    var appointment = provider.appointments[appointmentIndex];

    final formKey = GlobalKey<FormState>();
    final TextEditingController titleController =
        TextEditingController(text: appointment.title);
    final TextEditingController descriptionController =
        TextEditingController(text: appointment.description);
    final TextEditingController institutionNameController =
        TextEditingController(text: appointment.institutionName);
    final TextEditingController addressController =
        TextEditingController(text: appointment.address);
    DateTime? selectedDateTime = appointment.appointmentDate;
    bool showDateTimeError = false;
    String dateTimeErrorMessage = '';
    bool _isLoading = false;
    bool _isInAlertDialog = true;
    StateSetter? _setStateDialog;

    showDialog(
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          title: 'Edit Appointment',
          content: StatefulBuilder(
            builder: (context, setStateDialog) {
              _setStateDialog = setStateDialog;
              return Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: titleController,
                        decoration: InputDecoration(
                          floatingLabelStyle: const TextStyle(
                            color: AppMainTheme.blueLevelFive,
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppMainTheme.blueLevelFive,
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppMainTheme.black,
                              width: 1.0,
                            ),
                          ),
                          labelText: 'Title',
                          labelStyle: TextStyle(
                            color: AppMainTheme.black.withOpacity(0.6),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: InputValidators.appointmentTitleValidator,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: descriptionController,
                        decoration: InputDecoration(
                          floatingLabelStyle: const TextStyle(
                            color: AppMainTheme.blueLevelFive,
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppMainTheme.blueLevelFive,
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppMainTheme.black,
                              width: 1.0,
                            ),
                          ),
                          labelText: 'Description',
                          labelStyle: TextStyle(
                            color: AppMainTheme.black.withOpacity(0.6),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator:
                            InputValidators.appointmentDescriptionValidator,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: institutionNameController,
                        decoration: InputDecoration(
                          floatingLabelStyle: const TextStyle(
                            color: AppMainTheme.blueLevelFive,
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppMainTheme.blueLevelFive,
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppMainTheme.black,
                              width: 1.0,
                            ),
                          ),
                          labelText: 'Institution Name',
                          labelStyle: TextStyle(
                            color: AppMainTheme.black.withOpacity(0.6),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: InputValidators.institutionNameValidator,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: addressController,
                        decoration: InputDecoration(
                          floatingLabelStyle: const TextStyle(
                            color: AppMainTheme.blueLevelFive,
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppMainTheme.blueLevelFive,
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppMainTheme.black,
                              width: 1.0,
                            ),
                          ),
                          labelText: 'Address',
                          labelStyle: TextStyle(
                            color: AppMainTheme.black.withOpacity(0.6),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: InputValidators.addressValidator,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Text(selectedDateTime == null
                                ? 'Select Date and Time'
                                : DateFormat('y-MM-dd HH:mm')
                                    .format(selectedDateTime!)),
                          ),
                          IconButton(
                            icon: const Icon(Icons.calendar_today,
                                color: AppMainTheme.blueLevelFive),
                            onPressed: () async {
                              DatePicker.showDateTimePicker(
                                context,
                                showTitleActions: true,
                                minTime: DateTime.now(),
                                onChanged: (date) {},
                                onConfirm: (date) {
                                  if (context.mounted) {
                                    _setStateDialog!(() {
                                      selectedDateTime = date;
                                      showDateTimeError = false;
                                    });
                                  }
                                },
                                currentTime: selectedDateTime ?? DateTime.now(),
                                locale: LocaleType.en,
                              );
                            },
                          ),
                        ],
                      ),
                      if (showDateTimeError)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            dateTimeErrorMessage,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
          cancelButtonText: 'Cancel',
          confirmButtonText: 'Update',
          onCancel: () {
            Navigator.of(context).pop();
            _isInAlertDialog = false;
            _setStateDialog = null;
          },
          onConfirm: () async {
            if (formKey.currentState!.validate()) {
              if (selectedDateTime == null) {
                if (context.mounted) {
                  _setStateDialog!(() {
                    showDateTimeError = true;
                    dateTimeErrorMessage = 'Date and time are required';
                  });
                }
                return;
              }

              DateTime appointmentDate = selectedDateTime!;

              if (appointmentDate.isBefore(DateTime.now())) {
                if (context.mounted) {
                  _setStateDialog!(() {
                    showDateTimeError = true;
                    dateTimeErrorMessage =
                        'Date and time cannot be in the past';
                  });
                }
                return;
              }

              if (context.mounted) {
                _setStateDialog!(() {
                  _isLoading = true;
                });
              }

              PatchAppointmentRequest request = PatchAppointmentRequest(
                appointmentId: appointmentId,
                title: titleController.text,
                description: descriptionController.text,
                appointmentDate: appointmentDate,
                institutionName: institutionNameController.text,
                address: addressController.text,
              );

              try {
                await provider.updateAppointment(request);
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              } catch (e) {
                if (context.mounted) {
                  SnackbarManager.showErrorSnackBar(
                      context, 'Failed to update appointment');
                }
              } finally {
                if (context.mounted) {
                  _setStateDialog!(() {
                    _isLoading = false;
                  });
                }
              }
            } else {
              if (context.mounted) {
                _setStateDialog!(() {
                  if (selectedDateTime == null) {
                    showDateTimeError = true;
                    dateTimeErrorMessage = 'Date and time are required';
                  }
                });
              }
            }
          },
        );
      },
    ).whenComplete(() {
      _isInAlertDialog = false;
      _setStateDialog = null;
    });
  }

  void _showDeleteDialog(BuildContext context) {
    bool _isLoading = false;

    showDialog(
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          title: 'Confirm Deletion',
          content: const Text(
            'Are you sure you want to delete this appointment?',
            style: TextStyle(fontSize: 15),
          ),
          cancelButtonText: 'Cancel',
          confirmButtonText: 'Delete',
          onCancel: () => Navigator.of(context).pop(),
          onConfirm: () async {
            setLoadingState(bool isLoading) {
              _isLoading = isLoading;
            }

            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return LoadingOverlay(isLoading: _isLoading);
              },
            );

            try {
              setLoadingState(true);
              await Provider.of<AppointmentsProvider>(context, listen: false)
                  .deleteAppointment(appointmentId);
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            } catch (e) {
              if (context.mounted) {
                SnackbarManager.showErrorSnackBar(
                    context, "Failed to delete appointment");
              }
            } finally {
              setLoadingState(false);
            }
          },
        );
      },
    );
  }
}
