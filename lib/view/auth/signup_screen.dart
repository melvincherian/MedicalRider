
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medical_delivery_app/providers/signup_provider.dart';
import 'package:medical_delivery_app/view/auth/splash_screen.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  File? _drivingLicenseImage;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SignupProvider>().resetState();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(bool isProfile) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          if (isProfile) {
            _profileImage = File(image.path);
          } else {
            _drivingLicenseImage = File(image.path);
          }
        });
        context.read<SignupProvider>().clearError();
      }
    } catch (e) {
      _showSnackBar('Error picking image: $e', isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red[600] : Colors.green[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _handleSignup() async {
    context.read<SignupProvider>().clearError();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_profileImage == null) {
      _showSnackBar('Please upload your profile picture', isError: true);
      return;
    }

    if (_drivingLicenseImage == null) {
      _showSnackBar('Please upload your driving license', isError: true);
      return;
    }

    final signupProvider = context.read<SignupProvider>();

    try {
      print('Starting signup process...');

      final success = await signupProvider.signupRider(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        password: _passwordController.text,
        drivingLicensePath: _drivingLicenseImage!.path,
        profileImage: _profileImage!.path,
      );

      print('Signup result: $success');

      if (!mounted) return;

      if (success) {
        print('Signup successful, showing success message');
        _showSnackBar('Account created successfully!');

        await Future.delayed(const Duration(milliseconds: 800));

        if (!mounted) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SplashScreen()),
          (Route<dynamic> route) => false,
        );
      } else {
        String errorMsg =
            signupProvider.errorMessage ?? 'Signup failed. Please try again.';
        _showSnackBar(errorMsg, isError: true);
      }
    } catch (e) {
      print('Exception during signup: $e');
      if (mounted) {
        _showSnackBar('An error occurred: $e', isError: true);
      }
    }
  }

  String? _validateName(String? value) {
    final provider = context.read<SignupProvider>();
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (!provider.isValidName(value)) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final provider = context.read<SignupProvider>();
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!provider.isValidEmail(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    final provider = context.read<SignupProvider>();
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    if (value.length != 10) {
      return 'Phone number must be exactly 10 digits';
    }
    if (!provider.isValidPhone(value)) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final provider = context.read<SignupProvider>();
    if (value == null || value.trim().isEmpty) {
      return 'Password is required';
    }
    if (!provider.isValidPassword(value)) {
      return 'Password must include uppercase, lowercase, number, and special character';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Create Your Account',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Consumer<SignupProvider>(
          builder: (context, signupProvider, child) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (signupProvider.state == SignupState.error &&
                  signupProvider.errorMessage != null) {
                _showSnackBar(signupProvider.errorMessage!, isError: true);
              }
            });

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Join Us Today',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Create your account to get started',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),

                    // Profile Image Upload Section
                    _buildProfileImageSection(),
                    const SizedBox(height: 30),

                    // Name Field
                    _buildTextField(
                      controller: _nameController,
                      label: 'Full Name',
                      hint: 'Enter your full name',
                      icon: Icons.person_outline,
                      validator: _validateName,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 20),

                    // Email Field
                    _buildTextField(
                      controller: _emailController,
                      label: 'Email Address',
                      hint: 'Enter your email',
                      icon: Icons.email_outlined,
                      validator: _validateEmail,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 20),

                    // Phone Field
                    _buildTextField(
                      controller: _phoneController,
                      label: 'Phone Number',
                      hint: 'Enter your phone number',
                      icon: Icons.phone_outlined,
                      validator: _validatePhone,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      maxLength: 10, // Add this
                      inputFormatters: [
                        // Add this
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Password Field
                    _buildTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hint: 'Enter your password',
                      icon: Icons.lock_outline,
                      validator: _validatePassword,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Driving License Upload
                    _buildImageUploadSection(),
                    const SizedBox(height: 40),

                    // Sign Up Button
                    ElevatedButton(
                      onPressed: signupProvider.isLoading
                          ? null
                          : _handleSignup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: signupProvider.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              'Create Account',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Widget _buildTextField({
  //   required TextEditingController controller,
  //   required String label,
  //   required String hint,
  //   required IconData icon,
  //   required String? Function(String?) validator,
  //   TextInputType? keyboardType,
  //   TextInputAction? textInputAction,
  //   bool obscureText = false,
  //   Widget? suffixIcon,
  // }) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         label,
  //         style: const TextStyle(
  //           fontSize: 16,
  //           fontWeight: FontWeight.w500,
  //           color: Colors.black87,
  //         ),
  //       ),
  //       const SizedBox(height: 8),
  //       TextFormField(
  //         controller: controller,
  //         validator: validator,
  //         keyboardType: keyboardType,
  //         textInputAction: textInputAction,
  //         obscureText: obscureText,
  //         decoration: InputDecoration(
  //           hintText: hint,
  //           prefixIcon: Icon(icon, color: Colors.grey[600]),
  //           suffixIcon: suffixIcon,
  //           filled: true,
  //           fillColor: Colors.white,
  //           border: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(12),
  //             borderSide: BorderSide(color: Colors.grey[300]!),
  //           ),
  //           enabledBorder: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(12),
  //             borderSide: BorderSide(color: Colors.grey[300]!),
  //           ),
  //           focusedBorder: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(12),
  //             borderSide: BorderSide(color: Colors.blue[600]!, width: 2),
  //           ),
  //           errorBorder: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(12),
  //             borderSide: const BorderSide(color: Colors.red, width: 2),
  //           ),
  //           contentPadding: const EdgeInsets.symmetric(
  //             horizontal: 16,
  //             vertical: 16,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    bool obscureText = false,
    Widget? suffixIcon,
    int? maxLength, // Add this parameter
    List<TextInputFormatter>? inputFormatters, // Add this parameter
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          obscureText: obscureText,
          maxLength: maxLength, // Add this
          inputFormatters: inputFormatters, // Add this
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.grey[600]),
            suffixIcon: suffixIcon,
            counterText: maxLength != null
                ? ''
                : null, // Add this to hide counter
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue[600]!, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileImageSection() {
    return Column(
      children: [
        const Text(
          'Profile Picture',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => _pickImage(true),
          child: Stack(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _profileImage == null
                        ? Colors.grey[300]!
                        : Colors.blue[600]!,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: _profileImage == null
                    ? Icon(
                        Icons.person_outline,
                        size: 50,
                        color: Colors.grey[400],
                      )
                    : ClipOval(
                        child: Image.file(
                          _profileImage!,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.blue[600],
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: Icon(
                    _profileImage == null ? Icons.add_a_photo : Icons.edit,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _profileImage == null
              ? 'Tap to add profile picture'
              : 'Tap to change picture',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        if (_profileImage != null) ...[
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: Colors.green[600], size: 14),
              const SizedBox(width: 4),
              Text(
                'Picture uploaded',
                style: TextStyle(
                  color: Colors.green[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildImageUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Driving License',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _pickImage(false),
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _drivingLicenseImage == null
                    ? Colors.grey[300]!
                    : Colors.blue[600]!,
                width: _drivingLicenseImage == null ? 1 : 2,
              ),
            ),
            child: _drivingLicenseImage == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_upload_outlined,
                        size: 48,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Upload Driving License',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tap to select from gallery',
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      ),
                    ],
                  )
                : Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _drivingLicenseImage!,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                _drivingLicenseImage = null;
                              });
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () => _pickImage(false),
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        if (_drivingLicenseImage != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green[600], size: 16),
              const SizedBox(width: 4),
              Text(
                'License uploaded successfully',
                style: TextStyle(
                  color: Colors.green[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
