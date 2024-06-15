import 'package:flutter/material.dart';
import 'package:frontend_flutter/actions/home_actions.dart';
import 'package:frontend_flutter/api/models/responses/prediction_responses/prediction_response.dart';
import 'package:frontend_flutter/app/photo_handler.dart';
import 'package:frontend_flutter/app/session_manager.dart';
import 'package:frontend_flutter/app/snackbar_manager.dart';
import 'package:frontend_flutter/data_providers/predictions_provider.dart';
import 'package:frontend_flutter/screens/appointments_screen_body.dart';
import 'package:frontend_flutter/screens/chat_screen_body.dart';
import 'package:frontend_flutter/screens/information_screen_body.dart';
import 'package:frontend_flutter/screens/locations_screen_body.dart';
import 'package:frontend_flutter/app/app_main_theme.dart';
import 'package:frontend_flutter/screens/predictions_screen_body.dart';
import 'package:frontend_flutter/screens/profile_screen_body.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _actionsPerformed = false;

  static final List<Widget> _widgetOptions = <Widget>[
    const PredictionsScreenBody(),
    ChatScreenBody(),
    const InformationScreenBody(),
    const LocationsScreenBody(),
    AppointmentsScreenBody(),
    const ProfileScreenBody(),
  ];

  static final List<String> _appBarTitles = <String>[
    'Results',
    'ChatAI',
    'Info',
    'Clinics',
    'Visits',
    'Profile',
  ];

  static final List<String> _imagePaths = [
    'assets/icons/results.png',
    'assets/icons/chat_ai.png',
    'assets/icons/info.png',
    'assets/icons/clinic.png',
    'assets/icons/meetings.png',
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
    });
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 80.0,
        elevation: 8.0,
        color: AppMainTheme.blueLevelFive,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const SizedBox(width: 5),
            buildNavBarItemWithLabel(_imagePaths[0], 0),
            const SizedBox(width: 25),
            buildNavBarItemWithLabel(_imagePaths[1], 1),
            const SizedBox(width: 25),
            buildNavBarItemWithLabel(_imagePaths[2], 2),
            const Spacer(),
            buildNavBarItemWithLabel(_imagePaths[3], 3),
            const SizedBox(width: 25),
            buildNavBarItemWithLabel(_imagePaths[4], 4),
            const SizedBox(width: 25),
            buildProfileNavBarItem(5),
            const SizedBox(width: 5),
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
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF00C9FF), Color(0xFF92FE9D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Image.asset(
                'assets/icons/camera.png',
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
        splashColor: AppMainTheme.blueLevelFour,
        radius: 100.0,
        onTap: () => _onItemTapped(index),
        borderRadius: const BorderRadius.horizontal(
          left: Radius.circular(50.0),
          right: Radius.circular(50.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              imagePath,
              width: 24,
              height: 24,
              color: isSelected
                  ? AppMainTheme.white
                  : AppMainTheme.white.withOpacity(0.8),
            ),
            Visibility(
              visible: isSelected,
              child: Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Text(
                  _appBarTitles[index],
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 7,
                    color: AppMainTheme.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProfileNavBarItem(int index) {
    bool isSelected = _selectedIndex == index;
    String? profilePhoto = SessionManager.getProfilePhoto();
    String firstName = SessionManager.getFirstName() ?? '';
    String lastName = SessionManager.getLastName() ?? '';
    String initials =
        '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}';

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: InkWell(
        splashColor: AppMainTheme.blueLevelFour,
        radius: 100.0,
        onTap: () => _onItemTapped(index),
        borderRadius: const BorderRadius.horizontal(
          left: Radius.circular(50.0),
          right: Radius.circular(50.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            profilePhoto != null && profilePhoto.isNotEmpty
                ? CircleAvatar(
                    radius: 13,
                    backgroundImage: NetworkImage(profilePhoto),
                  )
                : CircleAvatar(
                    radius: 13,
                    backgroundColor: isSelected
                        ? AppMainTheme.white
                        : AppMainTheme.white.withOpacity(0.8),
                    child: Text(
                      initials,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
            Visibility(
              visible: isSelected,
              child: Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Text(
                  _appBarTitles[index],
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 7,
                    color: AppMainTheme.white,
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
                leading: const Icon(Icons.photo_library,
                    color: AppMainTheme.blueLevelFive),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _handlePhotoSelection(PhotoSource.gallery, context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_camera,
                  color: AppMainTheme.blueLevelFive,
                ),
                title: const Text('Take a Photo'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _handlePhotoSelection(PhotoSource.camera, context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handlePhotoSelection(
      PhotoSource source, BuildContext context) async {
    final provider = Provider.of<PredictionsProvider>(context, listen: false);
    provider.setLoading(true);

    Prediction? prediction =
        await HomeActions.handlePhotoSelection(source, context);

    provider.setLoading(false);

    if (prediction != null) {
      provider.addPrediction(prediction);

      if (prediction.predictionId != null) {
        HomeActions.checkPredictionStatus(
            prediction.predictionId!, context, provider);
      }
    }
  }
}
