

// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:medical_delivery_app/profile/profile_detail_screen.dart';
import 'package:medical_delivery_app/utils/helper_function.dart';
import 'package:medical_delivery_app/view/documents/document_screen.dart';
import 'package:medical_delivery_app/view/privacy/about_us.dart';
import 'package:medical_delivery_app/view/privacy/help_screen.dart';
import 'package:medical_delivery_app/view/privacy/privacy_policy.dart';
import 'package:medical_delivery_app/view/query/query_screen.dart';
import 'package:provider/provider.dart';
import 'package:medical_delivery_app/providers/profile_provider.dart';
import 'package:medical_delivery_app/providers/login_provider.dart';
import 'package:medical_delivery_app/view/auth/splash_screen.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ProfileProvider>().initializeProfile();
      }
    });
  }

  Future<void> _logout(BuildContext context) async {
    if (_isLoggingOut) return;

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() {
        _isLoggingOut = true;
      });

      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const AlertDialog(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Logging out..."),
              ],
            ),
          ),
        );

        // Clear SharedPreferences data
        final result = await SharedPreferenceService.clearAllData();

        // Clear LoginProvider state
        if (mounted) {
          context.read<LoginProvider>().logout();
        }

        // Close loading dialog
        if (mounted) {
          Navigator.pop(context);
        }

        if (result) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.green,
                content: Text("Logout Successfully"),
                duration: Duration(milliseconds: 500),
              ),
            );

            // Small delay to show the snackbar
            await Future.delayed(const Duration(milliseconds: 300));

            // Navigate to SplashScreen and remove all previous routes
            if (mounted) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const SplashScreen(),
                ),
                (route) => false,
              );
            }
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.red,
                content: Text("Logout failed, try again."),
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          // Close loading dialog if still open
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text("An error occurred during logout: ${e.toString()}"),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoggingOut = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: const Icon(
          Icons.person_outline,
          color: Colors.black,
          size: 24,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<ProfileProvider>(
              builder: (context, profileProvider, child) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          _buildProfileAvatar(profileProvider),
                          if (profileProvider.isLoading)
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withOpacity(0.3),
                              ),
                              child: const Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profileProvider.rider?.name ?? 'Loading...',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            if (profileProvider.rider?.email != null &&
                                profileProvider.rider!.email.isNotEmpty)
                              Text(
                                profileProvider.rider!.email,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            if (profileProvider.error != null)
                              GestureDetector(
                                onTap: () {
                                  profileProvider.clearError();
                                  profileProvider.initializeProfile();
                                },
                                child: Text(
                                  'Tap to retry',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.red[600],
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const Divider(),
            const SizedBox(height: 10),

            _buildMenuItem(
              icon: Icons.person,
              iconColor: Colors.blue,
              title: 'Profile',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileDetailScreen(),
                  ),
                );
              },
            ),

            // _buildMenuItem(
            //   icon: Icons.history,
            //   iconColor: Colors.black,
            //   title: 'Orders History',
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const HistoryScreen(),
            //       ),
            //     );
            //   },
            // ),

            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20, bottom: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Support & Settings',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            _buildMenuItem(
              icon: Icons.privacy_tip_outlined,
              iconColor: Colors.orange,
              title: 'Privacy Policy',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrivacyPolicy(),
                  ),
                );
              },
            ),

            _buildMenuItem(
              icon: Icons.info_outline,
              iconColor: Colors.cyan,
              title: 'About Us',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutUs()),
                );
              },
            ),

            _buildMenuItem(
              icon: Icons.help_outline,
              iconColor: Colors.blue,
              title: 'Help',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HelpScreen()),
                );
              },
            ),

            _buildMenuItem(
              icon: Icons.article,
              iconColor: Colors.blue,
              title: 'Documents',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DocumentScreen(),
                  ),
                );
              },
            ),

            _buildMenuItem(
              icon: Icons.help_center_outlined,
              iconColor: Colors.green,
              title: 'Submit Query',
              onTap: () {
                final profileProvider = context.read<ProfileProvider>();
                final riderId = profileProvider.rider?.id;

                if (riderId != null && riderId.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QueryScreen(riderId: riderId),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Unable to load user data. Please try again.',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  profileProvider.initializeProfile();
                }
              },
            ),

            _buildMenuItem(
              icon: Icons.logout,
              iconColor: _isLoggingOut ? Colors.grey : Colors.purple,
              title: 'Logout',
              onTap: _isLoggingOut ? null : () => _logout(context),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileAvatar(ProfileProvider profileProvider) {
    if (profileProvider.rider?.profileImage != null &&
        profileProvider.rider!.profileImage.isNotEmpty) {
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[300],
          image: DecorationImage(
            image: NetworkImage(profileProvider.rider!.profileImage),
            fit: BoxFit.cover,
            onError: (exception, stackTrace) {
              print('Error loading profile image: $exception');
            },
          ),
        ),
      );
    } else {
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[200],
        ),
        child: Icon(Icons.person, size: 30, color: Colors.grey[600]),
      );
    }
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey[200]!, width: 0.5),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: onTap == null ? Colors.grey : Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              if (title == 'Logout' && _isLoggingOut)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                const Icon(
                  Icons.chevron_right,
                  color: Color.fromARGB(255, 0, 0, 0),
                  size: 25,
                ),
            ],
          ),
        ),
      ),
    );
  }
}