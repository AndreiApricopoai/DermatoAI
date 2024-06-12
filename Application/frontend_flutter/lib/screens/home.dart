import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend_flutter/api/api_calls/prediction_api.dart';
import 'package:frontend_flutter/api/models/requests/prediction_requests/get_prediction_request.dart';
import 'package:frontend_flutter/api/models/responses/prediction_responses/get_prediction_response.dart';
import 'package:frontend_flutter/api/models/responses/prediction_responses/prediction_response.dart';
import 'package:frontend_flutter/app/photo_handler.dart';
import 'package:frontend_flutter/app/session_manager.dart';
import 'package:frontend_flutter/app/snackbar_manager.dart';
import 'package:frontend_flutter/app/utils.dart';
import 'package:frontend_flutter/data_providers/predictions_provider.dart';
import 'package:frontend_flutter/screens/appointments_screen_body.dart';
import 'package:frontend_flutter/screens/chat_screen_body.dart';
import 'package:frontend_flutter/screens/information_screen_body.dart';
import 'package:frontend_flutter/screens/locations_screen_body.dart';
import 'package:frontend_flutter/app/app_main_theme.dart';
import 'package:frontend_flutter/screens/predictions_screen_body.dart';
import 'package:frontend_flutter/screens/profile_screen_body.dart';
import 'package:frontend_flutter/widgets/text_title.dart';
import 'package:frontend_flutter/api/models/requests/prediction_requests/create_prediction_request.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isLoading = false;
  bool _actionsPerformed = false;

  static final List<Widget> _widgetOptions = <Widget>[
    PredictionsScreenBody(),
    ChatScreenBody(),
    InformationScreenBody(),
    LocationsScreenBody(),
    AppointmentsScreenBody(),
    ProfileScreenBody(),
  ];

  static final List<String> _appBarTitles = <String>[
    'Results',
    'ChatAI',
    'Info',
    'Clinics',
    'Meets',
    'Profile',
  ];

  static final List<String> _imagePaths = [
    'assets/icons/results.png',
    'assets/icons/chat_ai.png',
    'assets/icons/info.png',
    'assets/icons/clinic.png',
    'assets/icons/meetings.png',
    'assets/icons/profile.png',
  ];

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_actionsPerformed) {
        final arguments = ModalRoute.of(context)?.settings.arguments as Map?;
        if (arguments != null && arguments.containsKey('actions')) {
          final List<int> actions = arguments['actions'];
          for (int action in actions) {
            SnackbarManager.performSnackBarAction(action, context);
          }
          _actionsPerformed = true;
        }
      }

      print(SessionManager.getFirstName());
      print(SessionManager.getLastName());
      print(SessionManager.getEmail());
      print(SessionManager.getProfilePhoto());
      print(SessionManager.getVerified());
      print(SessionManager.getRefreshToken());
      print(SessionManager.getAccessToken());
      print(SessionManager.getIsGoogleUser());
    });
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
      bottomNavigationBar: BottomAppBar(
        height: 75.0,
        elevation: 8.0,
        color: AppMainTheme.blueLevelFive,
        shape: CircularNotchedRectangle(),
        notchMargin: 4.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(width: 5),
            buildNavBarItemWithLabel(_imagePaths[0], 0),
            SizedBox(width: 25),
            buildNavBarItemWithLabel(_imagePaths[1], 1),
            SizedBox(width: 25),
            buildNavBarItemWithLabel(_imagePaths[2], 2),
            Spacer(),
            buildNavBarItemWithLabel(_imagePaths[3], 3),
            SizedBox(width: 25),
            buildNavBarItemWithLabel(_imagePaths[4], 4),
            SizedBox(width: 25),
            buildNavBarItemWithLabel(_imagePaths[5], 5),
            SizedBox(width: 5),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 56,
        height: 56,
        child: FloatingActionButton(
          onPressed: () => _showPhotoOptions(context),
          tooltip: 'Take Photo',
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF00C9FF), Color(0xFF92FE9D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Image.asset(
                'assets/icons/clinic.png',
                width: 30,
                height: 30,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget buildNavBarItemWithLabel(String imagePath, int index) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: InkWell(
        splashColor: AppMainTheme.blueLevelFour.withOpacity(0.5),
        radius: 100.0,
        onTap: () => _onItemTapped(index),
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(50.0),
          right: Radius.circular(50.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              imagePath,
              width: 22,
              height: 22,
              color: isSelected
                  ? Colors.orange.shade300
                  : AppMainTheme.blueLevelOne,
            ),
            Visibility(
              visible: isSelected,
              child: Padding(
                padding: const EdgeInsets.only(top: 1.0),
                child: Text(
                  _appBarTitles[index],
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 9,
                    color: isSelected ? Colors.orange.shade300 : Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  _handlePhotoSelection(PhotoSource.gallery, context);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Take a Photo'),
                onTap: () async {
                  Navigator.of(context).pop();
                  _handlePhotoSelection(PhotoSource.camera, context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void addPredictionSafely(Prediction prediction) {
    if (context.mounted) {
      Provider.of<PredictionsProvider>(context, listen: false)
          .addPrediction(prediction);
    }
    if (prediction.predictionId != null) {
      checkPredictionStatus(prediction.predictionId!, context);
    }
  }

  void checkPredictionStatus(String predictionId, BuildContext context) {
    const Duration checkInterval = Duration(seconds: 10);
    const Duration timeout = Duration(minutes: 1);
    Timer? timer;

    timer = Timer.periodic(checkInterval, (Timer t) async {
      // Check if the timer has exceeded the timeout duration
      if (t.tick >= (timeout.inSeconds / checkInterval.inSeconds)) {
        t.cancel();
      }

      try {
        // Fetch the current status of the prediction
        GetPredictionResponse prediction =
            await getPredictionStatus(predictionId);
        // If the status is no longer pending, update and cancel the timer
        if (prediction.status != "pending") {
          t.cancel();

          Prediction processedPrediction = prediction.toPrediction();
          if (context.mounted) {
            Provider.of<PredictionsProvider>(context, listen: false)
                .addPrediction(processedPrediction);
          }
        } else {
          print("Prediction is still pending");
        }
      } catch (error) {
        print("Error checking prediction status: $error");
        t.cancel(); // Optionally handle error differently or keep the timer
      }
    });
  }

  Future<GetPredictionResponse> getPredictionStatus(String predictionId) async {
    GetPredictionRequest request =
        GetPredictionRequest(predictionId: predictionId);
    try {
      GetPredictionResponse response =
          await PredictionApi.getPrediction(request);
      return response;
    } catch (e) {
      print('Failed to fetch prediction status: $e');
      throw Exception('Failed to fetch prediction status');
    }
  }

// Use this callback in your asynchronous method
  void _handlePhotoSelection(PhotoSource source, BuildContext context) async {
    final photoHandler = PhotoHandler();

    setState(() {
      _isLoading = true;
    });

    CreatePredictionRequest? createPredictionRequest;
    if (source == PhotoSource.camera) {
      createPredictionRequest = await photoHandler.takePhoto(context);
      print("Camera selected");
    } else {
      createPredictionRequest = await photoHandler.pickImage(context);
      print("Gallery selected");
    }

    print('createPredictionRequest: $createPredictionRequest');

    if (createPredictionRequest == null) {
      print('No image selected');
    } else {
      print('Image selected');
    }

    Prediction? prediction;
    if (createPredictionRequest != null) {
      try {
        final response =
            await PredictionApi.createPrediction(createPredictionRequest);
        print("response is : ${response.error}");

        if (response.isSuccess) {
          // print rsposne is succes and some text

          print("response is : ${response.isSuccess}");

          prediction = response.toPrediction();
        } else {
          if (context.mounted) {
            print(
                "Failed to create prediction  Failed to create predictionFailed to create predictionFailed to create predictionFailed to create prediction");
            SnackbarManager.showErrorSnackBar(
                context, 'Failed to create prediction.');
          }
        }
      } catch (e) {
        print('Error: $e');
        if (context.mounted) {
          SnackbarManager.showErrorSnackBar(
              context, 'An error occurred. Please try again.');
        }
      }
    }

    setState(() {
      _isLoading = false;
      if (prediction != null) {
        addPredictionSafely(prediction);
      }
    });
  }
}

enum PhotoSource { gallery, camera }
