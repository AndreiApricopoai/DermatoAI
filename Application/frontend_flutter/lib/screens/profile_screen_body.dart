import 'package:flutter/material.dart';
import 'package:frontend_flutter/api/models/responses/user_responses/get_profile_response.dart';
import 'package:frontend_flutter/data_providers/profile_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreenBody extends StatefulWidget {
  @override
  _ProfileScreenBodyState createState() => _ProfileScreenBodyState();
}

class _ProfileScreenBodyState extends State<ProfileScreenBody> {
  @override
  void initState() {
    super.initState();
    // Fetch profile data when the screen is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileProvider>(context, listen: false).fetchProfileData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
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
        return ProfileView(profile: profile);
      },
    );
  }
}

class ProfileView extends StatelessWidget {
  final GetProfileResponse profile;

  const ProfileView({Key? key, required this.profile}) : super(key: key);

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
              onPressed: () {
                // Implement your verification logic here
              },
              child: Text('Verify my email'),
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
