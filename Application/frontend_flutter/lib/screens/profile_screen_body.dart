import 'package:flutter/material.dart';
import 'package:frontend_flutter/actions/profile_actions.dart';
import 'package:frontend_flutter/api/api_constants.dart';
import 'package:frontend_flutter/api/models/responses/user_responses/get_profile_response.dart';
import 'package:frontend_flutter/data_providers/profile_provider.dart';
import 'package:frontend_flutter/app/app_main_theme.dart';
import 'package:frontend_flutter/widgets/loading_overlay.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfileScreenBody extends StatefulWidget {
  const ProfileScreenBody({super.key});

  @override
  _ProfileScreenBodyState createState() => _ProfileScreenBodyState();
}

class _ProfileScreenBodyState extends State<ProfileScreenBody> {
  bool _isLoading = false;

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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            toolbarHeight: 65.0,
            backgroundColor: AppMainTheme.blueLevelFive,
            title: Text(
              'Profile',
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          body: Consumer<ProfileProvider>(
            builder: (context, profileProvider, child) {
              final profile = profileProvider.profileData ??
                  GetProfileResponse.fromSession();

              return ProfileView(
                profile: profile,
                onSendVerificationEmail: () =>
                    ProfileActions.sendVerificationEmail(
                        context, profile.email!, _setLoading),
                onSendFeedback: () =>
                    ProfileActions.showFeedbackDialog(context, _setLoading),
                onLogout: () => ProfileActions.logout(context, _setLoading),
                onChangePassword: profile.isGoogleUser == false
                    ? () => ProfileActions.showChangePasswordDialog(
                        context, _setLoading)
                    : null,
              );
            },
          ),
        ),
        if (_isLoading)
          Positioned.fill(
            child: LoadingOverlay(isLoading: _isLoading),
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
  final VoidCallback? onChangePassword;
  final String termsUrl = '${ApiConstants.baseUrlStaticFiles}terms';
  final String policyUrl = '${ApiConstants.baseUrlStaticFiles}policy';

  const ProfileView({
    super.key,
    required this.profile,
    required this.onSendVerificationEmail,
    required this.onSendFeedback,
    required this.onLogout,
    this.onChangePassword,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            CircleAvatar(
              radius: 50,
              backgroundColor: AppMainTheme.blueLevelFour,
              child: CircleAvatar(
                radius: 46,
                backgroundColor: AppMainTheme.blueLevelFour,
                backgroundImage: profile.profilePhoto != null
                    ? NetworkImage(profile.profilePhoto!)
                    : null,
                child: profile.profilePhoto == null
                    ? Text(
                        '${profile.firstName?[0] ?? ''}${profile.lastName?[0] ?? ''}',
                        style: const TextStyle(
                            fontSize: 40, color: AppMainTheme.white),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${profile.firstName ?? ''} ${profile.lastName ?? ''}',
              style: GoogleFonts.roboto(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              profile.email ?? '',
              style: GoogleFonts.roboto(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            if (profile.verified == false) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Your email is not verified',
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      color: Colors.red,
                    ),
                  ),
                  TextButton(
                    onPressed: onSendVerificationEmail,
                    child: Text(
                      'VERIFY NOW',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
            const SizedBox(height: 24),
            buildProfileOption(Icons.privacy_tip, 'Privacy Policy', () {
              ProfileActions.launchURL(context, policyUrl);
            }),
            buildProfileOption(Icons.feed, 'Terms & Conditions', () {
              ProfileActions.launchURL(context, termsUrl);
            }),
            buildProfileOption(Icons.send, 'Offer Feedback', onSendFeedback),
            if (onChangePassword != null)
              buildProfileOption(
                  Icons.lock, 'Change Password', onChangePassword!),
            buildProfileOption(Icons.logout, 'Log out', onLogout),
          ],
        ),
      ),
    );
  }

  Widget buildProfileOption(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                spreadRadius: 2,
                blurRadius: 5,
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: AppMainTheme.blueLevelFive),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 15.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
