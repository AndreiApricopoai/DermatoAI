import 'package:flutter/material.dart';
import 'package:frontend_flutter/utils/app_main_theme.dart';
import 'package:frontend_flutter/widgets/text_title.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    Text('Home Page Body', style: TextStyle(color: AppMainTheme.blueLevelFive, backgroundColor: Colors.black)),
    Text('Search Page Body'),
    Text('Camera Page Body'),
    Text('Alerts Page Body'),
    Text('Messages Page Body'),
    Text('Messages Page Body'),
    Text('Messages Page Body'),
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
      body: Center(
        
        child: _widgetOptions
            .elementAt(_selectedIndex), // Display the selected page body
      ),
      bottomNavigationBar: BottomAppBar(
        height: 75.0,
        elevation: 8.0, // Add elevation to give a shadow effect
        color: AppMainTheme.blueLevelFive,
        shape: CircularNotchedRectangle(),
        notchMargin: 4.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(width: 5), // Initial space for the notch
            buildNavBarItemWithLabel(_imagePaths[0], 0),
            SizedBox(width: 25), // Space between the first and second buttons
            buildNavBarItemWithLabel(_imagePaths[1], 1),
            SizedBox(width: 25), // Space between the second and third buttons
            buildNavBarItemWithLabel(_imagePaths[2], 2),
            Spacer(), // Space between the third and fourth buttons
            buildNavBarItemWithLabel(_imagePaths[3], 3),
            SizedBox(width: 25), // Space between the fourth and fifth buttons
            buildNavBarItemWithLabel(_imagePaths[4], 4),
            SizedBox(width: 25), // Space between the fifth and sixth buttons
            buildNavBarItemWithLabel(_imagePaths[5], 5),
            SizedBox(width: 5), // Final space for the notch
          ],
        ),
      ),
floatingActionButton: SizedBox(
  width: 56,
  height: 56,
  child: FloatingActionButton(
    onPressed: _takePhoto,
    tooltip: 'Take Photo',
    backgroundColor: Colors.transparent,
    elevation: 0,
    child: Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFF00C9FF), Color(0xFF92FE9D)], // Gradient colors
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

  void _takePhoto() {
    // Implement your camera logic here
  }
}
