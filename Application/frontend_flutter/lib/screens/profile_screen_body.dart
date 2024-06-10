import 'package:flutter/material.dart';
import 'package:frontend_flutter/api/models/requests/auth_requests/send_verification_email_request.dart';
import 'package:frontend_flutter/api/models/requests/feedback_requests/create_feedback_request.dart';
import 'package:frontend_flutter/api/models/requests/auth_requests/logout_request.dart';
import 'package:frontend_flutter/api/models/responses/base_response.dart';
import 'package:frontend_flutter/api/models/responses/user_responses/get_profile_response.dart';
import 'package:frontend_flutter/api/models/responses/auth_responses/logout_response.dart';
import 'package:frontend_flutter/app/session_manager.dart';
import 'package:frontend_flutter/app/snackbar_manager.dart';
import 'package:frontend_flutter/data_providers/profile_provider.dart';
import 'package:frontend_flutter/api/api_calls/feedback_api.dart';
import 'package:frontend_flutter/api/api_calls/auth_api.dart';
import 'package:provider/provider.dart';

class ProfileScreenBody extends StatefulWidget {
  @override
  _ProfileScreenBodyState createState() => _ProfileScreenBodyState();
}

class _ProfileScreenBodyState extends State<ProfileScreenBody> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Fetch profile data when the screen is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileProvider>(context, listen: false).fetchProfileData();
    });
  }

  Future<void> _sendVerificationEmail(BuildContext context, String email) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final request = SendVerificationEmailRequest(email: email);
      final response = await AuthApi.sendVerificationEmail(request);
      if (response.isSuccess) {
        SnackbarManager.showSuccessSnackBar(context, 'Verification email sent successfully');
      } else {
        SnackbarManager.showErrorSnackBar(context, 'Failed to send verification email');
      }
    } catch (e) {
      SnackbarManager.showErrorSnackBar(context, 'Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<bool> _sendFeedback(BuildContext context, String category, String content) async {
    setState(() {
      _isLoading = true;
    });
    print('Sending feedback: category=$category, content=$content');
    try {
      final request = CreateFeedbackRequest(category: category, content: content);
      final response = await FeedbackApi.sendFeedback(request);
      print(response.error);
      if (response.isSuccess) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _logout(BuildContext context) async {
    final refreshToken = SessionManager.getRefreshToken();
    if (refreshToken == null) {
      SnackbarManager.showErrorSnackBar(context, 'No refresh token found');
      return;
    }

    final bool? confirmLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Logout'),
            ),
          ],
        );
      },
    );

    if (confirmLogout == true) {
      try {
        final request = LogoutRequest(refreshToken: refreshToken);
        final response = await AuthApi.logout(request);
        if (response.isSuccess) {
          SessionManager.clearSession();
          Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
        } else {
          SnackbarManager.showErrorSnackBar(context, 'Failed to log out');
        }
      } catch (e) {
        SnackbarManager.showErrorSnackBar(context, 'Error: $e');
      }
    }
  }

  void _showFeedbackDialog(BuildContext context) {
    final TextEditingController contentController = TextEditingController();
    String category = 'app';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Send Feedback'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: category,
                items: ['app', 'bugs', 'usability', 'predictions', 'AIchat', 'other']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    category = newValue;
                  }
                },
                decoration: InputDecoration(labelText: 'Category'),
              ),
              TextField(
                controller: contentController,
                decoration: InputDecoration(labelText: 'Content'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                bool success = await _sendFeedback(context, category, contentController.text.trim());
                if(success) {
                  SnackbarManager.showSuccessSnackBar(context, 'Feedback sent successfully');
                } else {
                  SnackbarManager.showErrorSnackBar(context, 'Failed to send feedback');
                }
                
              },
              child: Text('Send'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Consumer<ProfileProvider>(
          builder: (context, profileProvider, child) {
            if (profileProvider.isLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (profileProvider.errorMessage != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(profileProvider.errorMessage!),
                    backgroundColor: Colors.red,
                  ),
                );
              });
              return Center(
                child: ElevatedButton(
                  onPressed: () {
                    profileProvider.resetError();
                    profileProvider.fetchProfileData();
                  },
                  child: Text('Retry'),
                ),
              );
            }
            final profile = profileProvider.profileData;
            if (profile == null) {
              return Center(child: Text('No profile data available.'));
            }
            return ProfileView(
              profile: profile,
              onSendVerificationEmail: () => _sendVerificationEmail(context, profile.email!),
              onSendFeedback: () => _showFeedbackDialog(context),
              onLogout: () => _logout(context),
            );
          },
        ),
        if (_isLoading)
          Container(
            color: Colors.black45,
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}

class ProfileView extends StatelessWidget {
  final GetProfileResponse profile;
  final VoidCallback onSendVerificationEmail;
  final VoidCallback onSendFeedback;
  final VoidCallback onLogout;

  const ProfileView({
    Key? key,
    required this.profile,
    required this.onSendVerificationEmail,
    required this.onSendFeedback,
    required this.onLogout,
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
              backgroundColor: profile.verified ?? false ? Colors.green : Colors.red,
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
