import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:frontend_flutter/data_providers/appointments_provider.dart';
import 'package:frontend_flutter/api/models/requests/appointment_requests/create_appointment_request.dart';
import 'package:frontend_flutter/app/snackbar_manager.dart';
import 'package:frontend_flutter/app/app_main_theme.dart';
import 'package:frontend_flutter/validators/input_validators.dart';
import 'package:frontend_flutter/widgets/text_title.dart';
import 'package:frontend_flutter/widgets/loading_overlay.dart';
import 'package:frontend_flutter/widgets/custom_alert_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'appointment_detail_screen.dart';

class AppointmentsScreenBody extends StatefulWidget {
  @override
  _AppointmentsScreenBodyState createState() => _AppointmentsScreenBodyState();
}

class _AppointmentsScreenBodyState extends State<AppointmentsScreenBody> {
  String searchQuery = "";
  bool isSearching = false;
  bool _isLoading = false;
  bool _isInAlertDialog = false; // Global variable to keep track of alert dialog state
  StateSetter? _setStateDialog;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AppointmentsProvider>(context, listen: false);
      provider.fetchAppointments();
    });
  }

  Future<void> _createAppointment(BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController institutionNameController = TextEditingController();
    final TextEditingController addressController = TextEditingController();
    DateTime? selectedDateTime;
    bool showDateTimeError = false;
    String dateTimeErrorMessage = '';

    _isInAlertDialog = true; // Set the alert dialog state to true when opening the dialog

    showDialog(
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          title: 'Create Appointment',
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
                        validator: InputValidators.appointmentDescriptionValidator,
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
                                : DateFormat('y-MM-dd HH:mm').format(selectedDateTime!)),
                          ),
                          IconButton(
                            icon: Icon(Icons.calendar_today, color: AppMainTheme.blueLevelFive),
                            onPressed: () async {
                              DatePicker.showDateTimePicker(
                                context,
                                showTitleActions: true,
                                minTime: DateTime.now(),
                                onChanged: (date) {},
                                onConfirm: (date) {
                                  if (mounted) {
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
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
          cancelButtonText: 'Cancel',
          confirmButtonText: 'Create',
          onCancel: () {
            Navigator.of(context).pop();
            _isInAlertDialog = false; // Reset the alert dialog state when the dialog is closed
            _setStateDialog = null;
          },
          onConfirm: () async {
            if (formKey.currentState!.validate()) {
              if (selectedDateTime == null) {
                if (mounted) {
                  _setStateDialog!(() {
                    showDateTimeError = true;
                    dateTimeErrorMessage = 'Date and time are required';
                  });
                }
                return;
              }

              DateTime appointmentDate = selectedDateTime!;

              if (appointmentDate.isBefore(DateTime.now())) {
                if (mounted) {
                  _setStateDialog!(() {
                    showDateTimeError = true;
                    dateTimeErrorMessage = 'Date and time cannot be in the past';
                  });
                }
                return;
              }

              if (mounted) {
                _setStateDialog!(() {
                  _isLoading = true;
                });
              }

              CreateAppointmentRequest request = CreateAppointmentRequest(
                title: titleController.text,
                description: descriptionController.text.isEmpty ? null : descriptionController.text,
                appointmentDate: appointmentDate,
                institutionName: institutionNameController.text.isEmpty ? null : institutionNameController.text,
                address: addressController.text.isEmpty ? null : addressController.text,
              );

              try {
                await Provider.of<AppointmentsProvider>(context, listen: false)
                    .createAppointment(request);
                Navigator.of(context).pop();
              } catch (e) {
                SnackbarManager.showErrorSnackBar(context,
                    'Failed to create appointment');
              } finally {
                if (mounted) {
                  _setStateDialog!(() {
                    _isLoading = false;
                  });
                }
              }
            } else {
              if (mounted) {
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

  @override
  void setState(VoidCallback fn) {
    if (_isInAlertDialog) {
      _setStateDialog?.call(fn);
    } else {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65.0,
        backgroundColor: AppMainTheme.blueLevelFive,
        title: isSearching
            ? buildSearchField()
            : const TextTitle(
                color: Colors.white,
                text: 'Appointments',
                fontSize: 24.0,
                fontFamily: GoogleFonts.roboto,
                fontWeight: FontWeight.w400,
              ),
        actions: [
          isSearching
              ? IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      isSearching = false;
                      searchQuery = '';
                    });
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      isSearching = true;
                    });
                  },
                ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              iconSize: 32.0,
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () => _createAppointment(context),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Consumer<AppointmentsProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return Center(child: LoadingOverlay(isLoading: true));
              }
              List appointments = provider.appointments.where((appointment) {
                return appointment.title
                        ?.toLowerCase()
                        .contains(searchQuery.toLowerCase()) ??
                    false;
              }).toList();

              if (appointments.isEmpty) {
                return _buildNoAppointmentsUI();
              } else {
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    var appointment = appointments[index];
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(
                          appointment.title ?? 'No Title',
                          style: GoogleFonts.roboto(
                            fontSize: 18.0, // Increased font size
                            fontWeight: FontWeight.w500, 
                            color: AppMainTheme.blueLevelFive,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (appointment.address != null &&
                                appointment.address!.isNotEmpty)
                              Text(
                                appointment.address!,
                                style: GoogleFonts.roboto(
                                  fontSize: 15.0, // Increased font size
                                  color: Colors.black87, // Darker text color
                                ),
                              ),
                            Text('Scheduled for: ${
                              DateFormat('dd-MM-y')
                                  .add_jm()
                                  .format(appointment.appointmentDate)}',
                              style: GoogleFonts.roboto(
                                fontSize: 12.0, // Smaller font size
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AppointmentDetailScreen(
                                appointmentId: appointment.id!),
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right,
                            color: AppMainTheme.blueLevelFive),
                      ),
                    );
                  },
                );
              }
            },
          ),
          if (_isLoading)
            LoadingOverlay(isLoading: _isLoading), // Overlay for loading
        ],
      ),
    );
  }

  Widget buildSearchField() {
    return TextField(
      autofocus: true,
      decoration: InputDecoration(
        hintText: "Enter appointment title",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (value) {
        setState(() {
          searchQuery = value;
        });
      },
    );
  }

  Widget _buildNoAppointmentsUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off,
            size: 70,
            color: Colors.grey,
          ),
          const SizedBox(height: 10),
          Text(
            'No appointments available.',
            style: GoogleFonts.roboto(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
