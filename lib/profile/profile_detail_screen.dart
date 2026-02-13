
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:medical_delivery_app/home/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:medical_delivery_app/providers/profile_provider.dart';

class ProfileDetailScreen extends StatefulWidget {
  const ProfileDetailScreen({super.key});

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().initializeProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: false,
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          if (profileProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF6C3DFF)),
            );
          }

          if (profileProvider.error != null) {
            return const Center(child: Text("Something went wrong"));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                // Profile Image + Name Row
                Row(
                  children: [
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () =>
                              profileProvider.showImagePickerOptions(context),
                          child: _buildProfileAvatar(profileProvider),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () =>
                                profileProvider.showImagePickerOptions(context),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: const Icon(
                                Icons.edit,
                                size: 16,
                                color: Colors.black,
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
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (profileProvider.selectedImage != null)
                            const Text(
                              'Tap save to update image',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),
                const Divider(),
                const SizedBox(height: 20),

                // Input Fields
                TextField(
                  controller: profileProvider.nameController,
                  decoration: InputDecoration(
                    labelText: "Full Name",
                    hintText: "Enter your full name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: profileProvider.phoneController,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    hintText: "Enter your phone number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: profileProvider.emailController,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "Enter your email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                  ),
                ),
                const SizedBox(height: 120),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C3DFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: profileProvider.isLoading
                        ? null
                        : () => _handleSave(context, profileProvider),
                    child: profileProvider.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Save",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileAvatar(ProfileProvider profileProvider) {
    if (profileProvider.selectedImage != null) {
      return CircleAvatar(
        radius: 40,
        backgroundImage: FileImage(profileProvider.selectedImage!),
      );
    } else if (profileProvider.rider?.profileImage != null &&
        profileProvider.rider!.profileImage.isNotEmpty) {
      return CircleAvatar(
        radius: 40,
        backgroundImage: NetworkImage(profileProvider.rider!.profileImage),
      );
    } else {
      return CircleAvatar(
        radius: 40,
        backgroundColor: Colors.grey.shade200,
        child: Icon(Icons.person, size: 40, color: Colors.grey.shade600),
      );
    }
  }

  Future<void> _handleSave(
    BuildContext context,
    ProfileProvider profileProvider,
  ) async {
    bool imageUpdateSuccess = true;
    bool profileUpdateSuccess = false;

    if (profileProvider.selectedImage != null) {
      imageUpdateSuccess = await profileProvider.updateProfileImage();
      if (!imageUpdateSuccess) {
        _showSnackBar(context, 'Failed to update profile image', isError: true);
        return;
      } else {
        _showSnackBar(context, 'Profile image updated successfully!');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
        return;
      }
    }

    profileUpdateSuccess = await profileProvider.updateProfile();

    if (profileUpdateSuccess) {
      _showSnackBar(context, 'Profile updated successfully!');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    }
  }

  void _showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
