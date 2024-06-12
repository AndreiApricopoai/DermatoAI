import 'package:flutter/material.dart';
import 'package:frontend_flutter/actions/profile_actions.dart';
import 'package:frontend_flutter/api/models/responses/user_responses/get_profile_response.dart';
import 'package:frontend_flutter/app/session_manager.dart';
import 'package:frontend_flutter/data_providers/profile_provider.dart';
import 'package:frontend_flutter/app/app_main_theme.dart';
import 'package:frontend_flutter/widgets/loading_overlay.dart'; 
import 'package:provider/provider.dart';

class ProfileScreenBody extends StatefulWidget {
  @override
  _ProfileScreenBodyState createState() => _ProfileScreenBodyState();
}

class _ProfileScreenBodyState extends State<ProfileScreenBody> {
  bool _isLoading = false;
  bool isSearching = false;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    ProfileActions.checkAndFetchVerifiedStatus(context, _setLoading);
  }

  void _setLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  Widget buildSearchField() {
    return TextField(
      autofocus: true,
      decoration: InputDecoration(
        hintText: "Enter search query",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
      ),
      style: TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (query) {
        setState(() {
          searchQuery = query;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.0,
        backgroundColor: AppMainTheme.blueLevelFive,
        title: isSearching
            ? buildSearchField()
            : Text("Profile", style: TextStyle(color: Colors.white)),
        actions: [
          isSearching
              ? IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      isSearching = false;
                      searchQuery = ''; // Clear search query
                    });
                  },
                )
              : IconButton(
                  icon: Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      isSearching = true;
                    });
                  },
                ),
        ],
      ),
      body: Stack(
        children: [
          Consumer<ProfileProvider>(
            builder: (context, profileProvider, child) {
              final profile = profileProvider.profileData ??
                  GetProfileResponse.fromSession();

              return ProfileView(
                profile: profile,
                onSendVerificationEmail: () => ProfileActions.sendVerificationEmail(
                    context, profile.email!, _setLoading),
                onSendFeedback: () => ProfileActions.showFeedbackDialog(
                    context, _setLoading),
                onLogout: () => ProfileActions.logout(context, _setLoading),
                onChangePassword: () => ProfileActions.showChangePasswordDialog(
                    context, _setLoading),
              );
            },
          ),
          LoadingOverlay(isLoading: _isLoading),
        ],
      ),
    );
  }
}

class ProfileView extends StatelessWidget {
  final GetProfileResponse profile;
  final VoidCallback onSendVerificationEmail;
  final VoidCallback onSendFeedback;
  final VoidCallback onLogout;
  final VoidCallback onChangePassword;

  const ProfileView({
    Key? key,
    required this.profile,
    required this.onSendVerificationEmail,
    required this.onSendFeedback,
    required this.onLogout,
    required this.onChangePassword,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor:
                  profile.verified ?? false ? Colors.green : Colors.red,
              child: profile.profilePhoto == null
                  ? Text(
                      '${profile.firstName?[0] ?? ''}${profile.lastName?[0] ?? ''}',
                      style: TextStyle(fontSize: 40, color: Colors.white),
                    )
                  : null,
              backgroundImage: profile.profilePhoto != null
                  ? NetworkImage(profile.profilePhoto!)
                  : null,
            ),
          ),
          SizedBox(height: 24),
          buildProfileItem('First Name', profile.firstName ?? ''),
          buildProfileItem('Last Name', profile.lastName ?? ''),
          buildProfileItem('Email', profile.email ?? ''),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Email Status: ',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              Text(
                profile.verified ?? false ? 'Verified' : 'Unverified',
                style: TextStyle(
                  fontSize: 16,
                  color: profile.verified ?? false ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          if (profile.verified == false) // Only show the button if not verified
            ElevatedButton(
              onPressed: onSendVerificationEmail,
              child: Text('Verify my email'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: onSendFeedback,
            child: Text('Send Feedback'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: onChangePassword,
            child: Text('Change Password'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: onLogout,
            child: Text('Logout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProfileItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

extension GetProfileResponseFromSession on GetProfileResponse {
  static GetProfileResponse fromSession() {
    return GetProfileResponse(
        firstName: SessionManager.getFirstName(),
        lastName: SessionManager.getLastName(),
        email: SessionManager.getEmail(),
        profilePhoto: SessionManager.getProfilePhoto(),
        verified: SessionManager.getVerified(),
        isSuccess: true,
        apiResponseCode: 1);
  }
}
