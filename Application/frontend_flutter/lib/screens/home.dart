import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend_flutter/api/api_calls/prediction_api.dart';
import 'package:frontend_flutter/app/photo_handler.dart';
import 'package:frontend_flutter/app/snackbar_manager.dart';
import 'package:frontend_flutter/screens/appointments_screen_body.dart';
import 'package:frontend_flutter/screens/chat_screen_body.dart';
import 'package:frontend_flutter/screens/information_screen_body.dart';
import 'package:frontend_flutter/screens/locations_screen_body.dart';
import 'package:frontend_flutter/screens/predictions_screen_body.dart';
import 'package:frontend_flutter/screens/profile_screen_body.dart';
import 'package:frontend_flutter/utils/app_main_theme.dart';
import 'package:frontend_flutter/widgets/text_title.dart';
import 'package:frontend_flutter/api/models/requests/prediction_requests/create_prediction_request.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isLoading = false;
  File? _imageFile;

  static List<Widget> _widgetOptions = <Widget>[
    PredictionsScreenBody(),
    ChatScreenBody(),
    InformationScreenBody(),
    LocationsScreenBody(),
    AppointmentsScreenBody(),
    ProfileScreenBody(),
  ];

  static List<String> _appBarTitles = <String>[
    'Results',
    'ChatAI',
    'Info',
    'Clinics',
    'Meets',
    'Profile',
  ];

  static List<String> _imagePaths = [
    'assets/icons/results.png',
    'assets/icons/chat_ai.png',
    'assets/icons/info.png',
    'assets/icons/clinic.png',
    'assets/icons/meetings.png',
    'assets/icons/profile.png',
  ];

  @override
  Widget build(BuildContext context) {
    final bool? verificationEmailSent = ModalRoute.of(context)?.settings.arguments as bool?;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (verificationEmailSent == true) {
        SnackbarManager.showSuccessSnackBar(context, 'Email verification sent successfully. Please check your inbox.');
      } else if (verificationEmailSent == false) {
        SnackbarManager.showErrorSnackBar(context, 'Failed to send verification email. Please try again later.');
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppMainTheme.blueLevelFive,
        title: TextTitle(
          text: _appBarTitles[_selectedIndex],
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
        actions: _selectedIndex == 0
            ? [
                IconButton(
                  icon: Icon(Icons.search, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.filter_list, color: Colors.white),
                  onPressed: () {},
                ),
              ]
            : null, // Actions only for home screen
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
              child:  _widgetOptions.elementAt(_selectedIndex),
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
              color: isSelected ? Colors.orange.shade300 : AppMainTheme.blueLevelOne,
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

  void _handlePhotoSelection(PhotoSource source, BuildContext context) async {
    final photoHandler = PhotoHandler();
    setState(() {
      _isLoading = true;
    });

    CreatePredictionRequest? createPredictionRequest;
    if (source == PhotoSource.camera) {
      createPredictionRequest = await photoHandler.takePhoto(context);
    } else {
      createPredictionRequest = await photoHandler.pickImage(context);
    }

    if (createPredictionRequest != null) {
      setState(() {
        _imageFile = createPredictionRequest?.image;
      });
      // Print the image path
      print('Selected image path: ${_imageFile!.path}');

      try {
        final predictionResponse = await PredictionApi.createPrediction(createPredictionRequest);
        if(predictionResponse.isSuccess)
        {
          print(predictionResponse.imageUrl);
          print(predictionResponse.dataMessage);print(predictionResponse.dataMessage);print(predictionResponse.dataMessage);print(predictionResponse.dataMessage);print(predictionResponse.dataMessage);
        }
        else
        {


        }
      } on Exception catch (e) {
        print('Error: $e');
      }
      
    }

    setState(() {
      _isLoading = false;
    });
  }
}

enum PhotoSource { gallery, camera }

