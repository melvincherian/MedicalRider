// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'package:medical_delivery_app/view/details/detail_screen.dart';

// class ImageUploadWidget extends StatefulWidget {
//   final String userId;
//   final String orderId;
//   final VoidCallback? onUploadSuccess;

//   const ImageUploadWidget({
//     Key? key,
//     required this.userId,
//     required this.orderId,
//     this.onUploadSuccess,
//   }) : super(key: key);

//   @override
//   State<ImageUploadWidget> createState() => _ImageUploadWidgetState();
// }

// class _ImageUploadWidgetState extends State<ImageUploadWidget> {
//   File? _selectedImage;
//   bool _isUploading = false;
//   final ImagePicker _picker = ImagePicker();

//   Future<void> _takePhoto() async {
//     try {
//       final XFile? photo = await _picker.pickImage(
//         source: ImageSource.camera,
//         maxWidth: 1920,
//         maxHeight: 1080,
//         imageQuality: 85,
//       );

//       if (photo != null) {
//         setState(() {
//           _selectedImage = File(photo.path);
//         });
//       }
//     } catch (e) {
//       _showErrorSnackbar('Failed to take photo: $e');
//     }
//   }

//   Future<void> _pickFromGallery() async {
//     try {
//       final XFile? image = await _picker.pickImage(
//         source: ImageSource.gallery,
//         maxWidth: 1920,
//         maxHeight: 1080,
//         imageQuality: 85,
//       );

//       if (image != null) {
//         setState(() {
//           _selectedImage = File(image.path);
//         });
//       }
//     } catch (e) {
//       _showErrorSnackbar('Failed to pick image: $e');
//     }
//   }

//   void _showImageSourceDialog() {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (BuildContext context) {
//         return Container(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Handle bar
//               Container(
//                 width: 32,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[400],
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               const SizedBox(height: 20),
              
//               const Text(
//                 'Select Image Source',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(height: 20),
              
//               // Camera option
//               ListTile(
//                 leading: Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF5931DD).withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: const Icon(
//                     Icons.camera_alt,
//                     color: Color(0xFF5931DD),
//                   ),
//                 ),
//                 title: const Text('Camera'),
//                 subtitle: const Text('Take a new photo'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _takePhoto();
//                 },
//               ),
              
        
//               const SizedBox(height: 10),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Future<void> _uploadImage() async {
//     if (_selectedImage == null) {
//       _showErrorSnackbar('Please select an image first');
//       return;
//     }

//     setState(() {
//       _isUploading = true;
//     });

//     try {
//       var request = http.MultipartRequest(
//         'POST',
//         Uri.parse('http://31.97.206.144:7021/api/rider/uploadDeliveryProof/${widget.userId}/${widget.orderId}'),
//       );

//       // Add the image file
//       request.files.add(
//         await http.MultipartFile.fromPath(
//           'image',
//           _selectedImage!.path,
//         ),
//       );

//       // Add additional data if needed
//       // request.fields['orderId'] = widget.orderId;
//       // request.fields['uploadType'] = 'delivery_proof';

//       // Send the request
//       var streamedResponse = await request.send();
//       var response = await http.Response.fromStream(streamedResponse);

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         // Success
//         final responseData = json.decode(response.body);
//         _showSuccessSnackbar('Image uploaded successfully!');
        
//         // Clear the selected image
//         setState(() {
//           _selectedImage = null;
//         });

// Navigator.pop(context);
        
//         // Call success callback
//         // if (widget.onUploadSuccess != null) {
//         //   widget.onUploadSuccess!();
//         // }
        
//         print('Upload successful: $responseData');
//       } else {
//         // Error
//         final errorData = json.decode(response.body);
//         _showErrorSnackbar('Upload failed: ${errorData['message'] ?? 'Unknown error'}');
//         print('Upload failed: ${response.statusCode} - ${response.body}');
//       }
//     } catch (e) {
//       _showErrorSnackbar('Upload failed: $e');
//       print('Upload error: $e');
//     } finally {
//       setState(() {
//         _isUploading = false;
//       });
//     }
//   }

//   void _removeImage() {
//     setState(() {
//       _selectedImage = null;
//     });
//   }

//   void _showErrorSnackbar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         margin: const EdgeInsets.all(16),
//       ),
//     );
//   }

//   void _showSuccessSnackbar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.green,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         margin: const EdgeInsets.all(16),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(20),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey[300]!),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Title
//           Row(
//             children: [
//               Icon(
//                 Icons.camera_alt,
//                 color: const Color(0xFF5931DD),
//                 size: 20,
//               ),
//               const SizedBox(width: 8),
//               const Text(
//                 'Upload Delivery Proof',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black,
//                 ),
//               ),
//             ],
//           ),
          
//           const SizedBox(height: 12),
          
//           Text(
//             'Take a photo as proof of delivery',
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey[600],
//             ),
//           ),
          
//           const SizedBox(height: 16),
          
//           // Image preview or placeholder
//           GestureDetector(
//             onTap: _selectedImage == null ? _showImageSourceDialog : null,
//             child: Container(
//               width: double.infinity,
//               height: 200,
//               decoration: BoxDecoration(
//                 color: Colors.grey[100],
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(
//                   color: Colors.grey[300]!,
//                   style: BorderStyle.solid,
//                 ),
//               ),
//               child: _selectedImage != null
//                   ? Stack(
//                       children: [
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(12),
//                           child: Image.file(
//                             _selectedImage!,
//                             width: double.infinity,
//                             height: 200,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         Positioned(
//                           top: 8,
//                           right: 8,
//                           child: GestureDetector(
//                             onTap: _removeImage,
//                             child: Container(
//                               padding: const EdgeInsets.all(4),
//                               decoration: BoxDecoration(
//                                 color: Colors.red,
//                                 shape: BoxShape.circle,
//                               ),
//                               child: const Icon(
//                                 Icons.close,
//                                 color: Colors.white,
//                                 size: 16,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     )
//                   : Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.add_a_photo,
//                           size: 48,
//                           color: Colors.grey[400],
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           'Tap to select image',
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.grey[500],
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//             ),
//           ),
          
//           const SizedBox(height: 16),
          
//           // Action buttons
//           Row(
//             children: [
//               if (_selectedImage == null) ...[
//                 Expanded(
//                   child: OutlinedButton.icon(
//                     onPressed: _showImageSourceDialog,
//                     icon: const Icon(Icons.camera_alt),
//                     label: const Text('Select Image'),
//                     style: OutlinedButton.styleFrom(
//                       foregroundColor: const Color(0xFF5931DD),
//                       side: const BorderSide(color: Color(0xFF5931DD)),
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ),
//                 ),
//               ] else ...[
//                 Expanded(
//                   child: OutlinedButton.icon(
//                     onPressed: _showImageSourceDialog,
//                     icon: const Icon(Icons.edit),
//                     label: const Text('Change Image'),
//                     style: OutlinedButton.styleFrom(
//                       foregroundColor: const Color(0xFF5931DD),
//                       side: const BorderSide(color: Color(0xFF5931DD)),
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     onPressed: _isUploading ? null : _uploadImage,
//                     icon: _isUploading
//                         ? const SizedBox(
//                             width: 16,
//                             height: 16,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               color: Colors.white,
//                             ),
//                           )
//                         : const Icon(Icons.cloud_upload),
//                     label: Text(_isUploading ? 'Uploading...' : 'Upload'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF5931DD),
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }












import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ImageUploadWidget extends StatefulWidget {
  final String userId;
  final String orderId;
  final VoidCallback? onUploadSuccess;

  const ImageUploadWidget({
    Key? key,
    required this.userId,
    required this.orderId,
    this.onUploadSuccess,
  }) : super(key: key);

  @override
  State<ImageUploadWidget> createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> with SingleTickerProviderStateMixin {
  File? _selectedImage;
  bool _isUploading = false;
  final ImagePicker _picker = ImagePicker();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (photo != null) {
        setState(() {
          _selectedImage = File(photo.path);
        });
        _animationController.forward(from: 0.0);
      }
    } catch (e) {
      _showErrorSnackbar('Failed to take photo: $e');
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
        _animationController.forward(from: 0.0);
      }
    } catch (e) {
      _showErrorSnackbar('Failed to pick image: $e');
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Upload Delivery Proof',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Text(
                    //   'Choose how you want to add the photo',
                    //   style: TextStyle(
                    //     fontSize: 14,
                    //     color: Colors.grey[600],
                    //     fontWeight: FontWeight.w400,
                    //   ),
                    // ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _buildSourceOption(
                      icon: Icons.camera_alt_rounded,
                      title: 'Take Photo',
                      subtitle: 'Use camera to capture',
                      gradient: const LinearGradient(
                        colors: [Color(0xFF5931DD), Color(0xFF7B52E8)],
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _takePhoto();
                      },
                    ),
                    // const SizedBox(height: 12),
                    // _buildSourceOption(
                    //   icon: Icons.photo_library_rounded,
                    //   title: 'Choose from Gallery',
                    //   subtitle: 'Select existing photo',
                    //   gradient: LinearGradient(
                    //     colors: [Colors.grey[700]!, Colors.grey[800]!],
                    //   ),
                    //   onTap: () {
                    //     Navigator.pop(context);
                    //     _pickFromGallery();
                    //   },
                    // ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) {
      _showErrorSnackbar('Please select an image first');
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://31.97.206.144:7021/api/rider/uploadDeliveryProof/${widget.userId}/${widget.orderId}'),
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          _selectedImage!.path,
        ),
      );

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        _showSuccessSnackbar('Image uploaded successfully!');
        
        setState(() {
          _selectedImage = null;
        });

        Navigator.pop(context);
        
        print('Upload successful: $responseData');
      } else {
        final errorData = json.decode(response.body);
        _showErrorSnackbar('Upload failed: ${errorData['message'] ?? 'Unknown error'}');
        print('Upload failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      _showErrorSnackbar('Upload failed: $e');
      print('Upload error: $e');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: const Color(0xFFDC2626),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        elevation: 6,
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: const Color(0xFF059669),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        elevation: 6,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.grey[50]!,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5931DD).withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF5931DD), Color(0xFF7B52E8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF5931DD).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Delivery Proof',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Text(
                        //   'Capture evidence of successful delivery',
                        //   style: TextStyle(
                        //     fontSize: 13,
                        //     color: Colors.white.withOpacity(0.9),
                        //     fontWeight: FontWeight.w400,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Content Section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Image preview or placeholder
                  GestureDetector(
                    onTap: _selectedImage == null ? _showImageSourceDialog : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: double.infinity,
                      height: 240,
                      decoration: BoxDecoration(
                        color: _selectedImage != null ? Colors.black : Colors.grey[100],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _selectedImage != null 
                              ? const Color(0xFF5931DD).withOpacity(0.3)
                              : Colors.grey[300]!,
                          width: 2,
                        ),
                        boxShadow: _selectedImage != null
                            ? [
                                BoxShadow(
                                  color: const Color(0xFF5931DD).withOpacity(0.2),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: _selectedImage != null
                          ? FadeTransition(
                              opacity: _fadeAnimation,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(14),
                                    child: Image.file(
                                      _selectedImage!,
                                      width: double.infinity,
                                      height: 240,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 12,
                                    right: 12,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: _removeImage,
                                        borderRadius: BorderRadius.circular(20),
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.red[500],
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.red.withOpacity(0.4),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: const Icon(
                                            Icons.close_rounded,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 12,
                                    left: 12,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.2),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.check_circle_rounded,
                                            color: Colors.green[400],
                                            size: 16,
                                          ),
                                          const SizedBox(width: 6),
                                          const Text(
                                            'Image Selected',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF5931DD).withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.add_a_photo_rounded,
                                    size: 48,
                                    color: const Color(0xFF5931DD).withOpacity(0.6),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Tap to Add Photo',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Text(
                                //   'Take a photo or choose from gallery',
                                //   style: TextStyle(
                                //     fontSize: 13,
                                //     color: Colors.grey[500],
                                //     fontWeight: FontWeight.w400,
                                //   ),
                                // ),
                              ],
                            ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Action buttons
                  if (_selectedImage == null)
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton.icon(
                        onPressed: _showImageSourceDialog,
                        icon: const Icon(Icons.add_photo_alternate_rounded, size: 22),
                        label: const Text(
                          'Select Image',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5931DD),
                          foregroundColor: Colors.white,
                          elevation: 4,
                          shadowColor: const Color(0xFF5931DD).withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            height: 54,
                            child: OutlinedButton.icon(
                              onPressed: _showImageSourceDialog,
                              // icon: const Icon(Icons.swap_horiz_rounded, size: 20),
                              label: const Text(
                                'Change',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF5931DD),
                                side: const BorderSide(
                                  color: Color(0xFF5931DD),
                                  width: 2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 3,
                          child: SizedBox(
                            height: 54,
                            child: ElevatedButton.icon(
                              onPressed: _isUploading ? null : _uploadImage,
                              icon: _isUploading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.cloud_upload_rounded, size: 22),
                              label: Text(
                                _isUploading ? 'Uploading...' : 'Upload Photo',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF5931DD),
                                foregroundColor: Colors.white,
                                elevation: 4,
                                shadowColor: const Color(0xFF5931DD).withOpacity(0.4),
                                disabledBackgroundColor: Colors.grey[400],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}