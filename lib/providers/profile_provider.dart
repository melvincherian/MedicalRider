import 'dart:io';
import 'package:flutter/material.dart';
import 'package:medical_delivery_app/models/login_model.dart';
import 'package:medical_delivery_app/services/profile_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medical_delivery_app/utils/helper_function.dart';

class ProfileProvider extends ChangeNotifier {
  RiderModel? _rider;
  bool _isLoading = false;
  String? _error;
  File? _selectedImage;

  // Controllers for text fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // Getters
  RiderModel? get rider => _rider;
  bool get isLoading => _isLoading;
  String? get error => _error;
  File? get selectedImage => _selectedImage;

  // Initialize profile data from SharedPreferences
  Future<void> initializeProfile() async {
    _setLoading(true);
    _error = null;

    try {
      // First try to get from SharedPreferences
      _rider = await SharedPreferenceService.getRiderData();
      
      if (_rider != null) {
        _populateControllers();
        
        // Then fetch updated data from API
        await fetchProfile(_rider!.id);
      }
    } catch (e) {
      _error = 'Failed to initialize profile: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Fetch profile from API
  Future<void> fetchProfile(String riderId) async {
    _setLoading(true);
    _error = null;

    try {
      final updatedRider = await ProfileService.getProfile(riderId);
      if (updatedRider != null) {
        _rider = updatedRider;
        _populateControllers();
        
        // Update SharedPreferences with latest data
        await SharedPreferenceService.saveRiderData(updatedRider);
      }
    } catch (e) {
      _error = 'Failed to fetch profile: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Update profile
  Future<bool> updateProfile() async {
    if (_rider == null) return false;

    _setLoading(true);
    _error = null;

    try {
      final profileData = {
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'email': emailController.text.trim(),
      };

      final success = await ProfileService.updateProfile(_rider!.id, profileData);
      
      if (success) {
        // Update local rider data
        _rider = RiderModel(
          id: _rider!.id,
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          phone: phoneController.text.trim(),
          address: _rider!.address,
          city: _rider!.city,
          state: _rider!.state,
          pinCode: _rider!.pinCode,
          latitude: _rider!.latitude,
          longitude: _rider!.longitude,
          profileImage: _rider!.profileImage,
          rideImages: _rider!.rideImages,
          createdAt: _rider!.createdAt,
          updatedAt: DateTime.now(),
          v: _rider!.v,
          deliveryCharge: _rider!.deliveryCharge,
          accountDetails: _rider!.accountDetails,
          wallet: _rider!.wallet,
          status: _rider!.status
        );
        
        // Save to SharedPreferences
        await SharedPreferenceService.saveRiderData(_rider!);
        
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = 'Failed to update profile: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Pick image from gallery or camera
  Future<void> pickImage({required ImageSource source}) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        _selectedImage = File(image.path);
        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to pick image: $e';
      notifyListeners();
    }
  }

  // Update profile image
  Future<bool> updateProfileImage() async {
    if (_rider == null || _selectedImage == null) return false;

    _setLoading(true);
    _error = null;

    try {
      final success = await ProfileService.updateProfileImage(_rider!.id, _selectedImage!);
      
      if (success) {
        // Refresh profile data to get updated image URL
        await fetchProfile(_rider!.id);
        _selectedImage = null; // Clear selected image
        return true;
      }
      return false;
    } catch (e) {
      _error = 'Failed to update profile image: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Show image picker options
  void showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  Navigator.of(context).pop();
                  pickImage(source: ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  pickImage(source: ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Private methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _populateControllers() {
    if (_rider != null) {
      nameController.text = _rider!.name;
      phoneController.text = _rider!.phone;
      emailController.text = _rider!.email;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }
}