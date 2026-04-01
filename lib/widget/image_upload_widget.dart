// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';

// // import 'package:medical_delivery_app/view/details/detail_screen.dart';

// // class ImageUploadWidget extends StatefulWidget {
// //   final String userId;
// //   final String orderId;
// //   final VoidCallback? onUploadSuccess;

// //   const ImageUploadWidget({
// //     Key? key,
// //     required this.userId,
// //     required this.orderId,
// //     this.onUploadSuccess,
// //   }) : super(key: key);

// //   @override
// //   State<ImageUploadWidget> createState() => _ImageUploadWidgetState();
// // }

// // class _ImageUploadWidgetState extends State<ImageUploadWidget> {
// //   File? _selectedImage;
// //   bool _isUploading = false;
// //   final ImagePicker _picker = ImagePicker();

// //   Future<void> _takePhoto() async {
// //     try {
// //       final XFile? photo = await _picker.pickImage(
// //         source: ImageSource.camera,
// //         maxWidth: 1920,
// //         maxHeight: 1080,
// //         imageQuality: 85,
// //       );

// //       if (photo != null) {
// //         setState(() {
// //           _selectedImage = File(photo.path);
// //         });
// //       }
// //     } catch (e) {
// //       _showErrorSnackbar('Failed to take photo: $e');
// //     }
// //   }

// //   Future<void> _pickFromGallery() async {
// //     try {
// //       final XFile? image = await _picker.pickImage(
// //         source: ImageSource.gallery,
// //         maxWidth: 1920,
// //         maxHeight: 1080,
// //         imageQuality: 85,
// //       );

// //       if (image != null) {
// //         setState(() {
// //           _selectedImage = File(image.path);
// //         });
// //       }
// //     } catch (e) {
// //       _showErrorSnackbar('Failed to pick image: $e');
// //     }
// //   }

// //   void _showImageSourceDialog() {
// //     showModalBottomSheet(
// //       context: context,
// //       shape: const RoundedRectangleBorder(
// //         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
// //       ),
// //       builder: (BuildContext context) {
// //         return Container(
// //           padding: const EdgeInsets.all(20),
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               // Handle bar
// //               Container(
// //                 width: 32,
// //                 height: 4,
// //                 decoration: BoxDecoration(
// //                   color: Colors.grey[400],
// //                   borderRadius: BorderRadius.circular(2),
// //                 ),
// //               ),
// //               const SizedBox(height: 20),
              
// //               const Text(
// //                 'Select Image Source',
// //                 style: TextStyle(
// //                   fontSize: 18,
// //                   fontWeight: FontWeight.w600,
// //                 ),
// //               ),
// //               const SizedBox(height: 20),
              
// //               // Camera option
// //               ListTile(
// //                 leading: Container(
// //                   padding: const EdgeInsets.all(8),
// //                   decoration: BoxDecoration(
// //                     color: const Color(0xFF5931DD).withOpacity(0.1),
// //                     borderRadius: BorderRadius.circular(8),
// //                   ),
// //                   child: const Icon(
// //                     Icons.camera_alt,
// //                     color: Color(0xFF5931DD),
// //                   ),
// //                 ),
// //                 title: const Text('Camera'),
// //                 subtitle: const Text('Take a new photo'),
// //                 onTap: () {
// //                   Navigator.pop(context);
// //                   _takePhoto();
// //                 },
// //               ),
              
        
// //               const SizedBox(height: 10),
// //             ],
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   Future<void> _uploadImage() async {
// //     if (_selectedImage == null) {
// //       _showErrorSnackbar('Please select an image first');
// //       return;
// //     }

// //     setState(() {
// //       _isUploading = true;
// //     });

// //     try {
// //       var request = http.MultipartRequest(
// //         'POST',
// //         Uri.parse('http://31.97.206.144:7021/api/rider/uploadDeliveryProof/${widget.userId}/${widget.orderId}'),
// //       );

// //       // Add the image file
// //       request.files.add(
// //         await http.MultipartFile.fromPath(
// //           'image',
// //           _selectedImage!.path,
// //         ),
// //       );

// //       // Add additional data if needed
// //       // request.fields['orderId'] = widget.orderId;
// //       // request.fields['uploadType'] = 'delivery_proof';

// //       // Send the request
// //       var streamedResponse = await request.send();
// //       var response = await http.Response.fromStream(streamedResponse);

// //       if (response.statusCode == 200 || response.statusCode == 201) {
// //         // Success
// //         final responseData = json.decode(response.body);
// //         _showSuccessSnackbar('Image uploaded successfully!');
        
// //         // Clear the selected image
// //         setState(() {
// //           _selectedImage = null;
// //         });

// // Navigator.pop(context);
        
// //         // Call success callback
// //         // if (widget.onUploadSuccess != null) {
// //         //   widget.onUploadSuccess!();
// //         // }
        
// //         print('Upload successful: $responseData');
// //       } else {
// //         // Error
// //         final errorData = json.decode(response.body);
// //         _showErrorSnackbar('Upload failed: ${errorData['message'] ?? 'Unknown error'}');
// //         print('Upload failed: ${response.statusCode} - ${response.body}');
// //       }
// //     } catch (e) {
// //       _showErrorSnackbar('Upload failed: $e');
// //       print('Upload error: $e');
// //     } finally {
// //       setState(() {
// //         _isUploading = false;
// //       });
// //     }
// //   }

// //   void _removeImage() {
// //     setState(() {
// //       _selectedImage = null;
// //     });
// //   }

// //   void _showErrorSnackbar(String message) {
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //         content: Text(message),
// //         backgroundColor: Colors.red,
// //         behavior: SnackBarBehavior.floating,
// //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
// //         margin: const EdgeInsets.all(16),
// //       ),
// //     );
// //   }

// //   void _showSuccessSnackbar(String message) {
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //         content: Text(message),
// //         backgroundColor: Colors.green,
// //         behavior: SnackBarBehavior.floating,
// //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
// //         margin: const EdgeInsets.all(16),
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       margin: const EdgeInsets.all(20),
// //       padding: const EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(12),
// //         border: Border.all(color: Colors.grey[300]!),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.05),
// //             blurRadius: 8,
// //             offset: const Offset(0, 2),
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           // Title
// //           Row(
// //             children: [
// //               Icon(
// //                 Icons.camera_alt,
// //                 color: const Color(0xFF5931DD),
// //                 size: 20,
// //               ),
// //               const SizedBox(width: 8),
// //               const Text(
// //                 'Upload Delivery Proof',
// //                 style: TextStyle(
// //                   fontSize: 16,
// //                   fontWeight: FontWeight.w600,
// //                   color: Colors.black,
// //                 ),
// //               ),
// //             ],
// //           ),
          
// //           const SizedBox(height: 12),
          
// //           Text(
// //             'Take a photo as proof of delivery',
// //             style: TextStyle(
// //               fontSize: 14,
// //               color: Colors.grey[600],
// //             ),
// //           ),
          
// //           const SizedBox(height: 16),
          
// //           // Image preview or placeholder
// //           GestureDetector(
// //             onTap: _selectedImage == null ? _showImageSourceDialog : null,
// //             child: Container(
// //               width: double.infinity,
// //               height: 200,
// //               decoration: BoxDecoration(
// //                 color: Colors.grey[100],
// //                 borderRadius: BorderRadius.circular(12),
// //                 border: Border.all(
// //                   color: Colors.grey[300]!,
// //                   style: BorderStyle.solid,
// //                 ),
// //               ),
// //               child: _selectedImage != null
// //                   ? Stack(
// //                       children: [
// //                         ClipRRect(
// //                           borderRadius: BorderRadius.circular(12),
// //                           child: Image.file(
// //                             _selectedImage!,
// //                             width: double.infinity,
// //                             height: 200,
// //                             fit: BoxFit.cover,
// //                           ),
// //                         ),
// //                         Positioned(
// //                           top: 8,
// //                           right: 8,
// //                           child: GestureDetector(
// //                             onTap: _removeImage,
// //                             child: Container(
// //                               padding: const EdgeInsets.all(4),
// //                               decoration: BoxDecoration(
// //                                 color: Colors.red,
// //                                 shape: BoxShape.circle,
// //                               ),
// //                               child: const Icon(
// //                                 Icons.close,
// //                                 color: Colors.white,
// //                                 size: 16,
// //                               ),
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     )
// //                   : Column(
// //                       mainAxisAlignment: MainAxisAlignment.center,
// //                       children: [
// //                         Icon(
// //                           Icons.add_a_photo,
// //                           size: 48,
// //                           color: Colors.grey[400],
// //                         ),
// //                         const SizedBox(height: 8),
// //                         Text(
// //                           'Tap to select image',
// //                           style: TextStyle(
// //                             fontSize: 14,
// //                             color: Colors.grey[500],
// //                             fontWeight: FontWeight.w500,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //             ),
// //           ),
          
// //           const SizedBox(height: 16),
          
// //           // Action buttons
// //           Row(
// //             children: [
// //               if (_selectedImage == null) ...[
// //                 Expanded(
// //                   child: OutlinedButton.icon(
// //                     onPressed: _showImageSourceDialog,
// //                     icon: const Icon(Icons.camera_alt),
// //                     label: const Text('Select Image'),
// //                     style: OutlinedButton.styleFrom(
// //                       foregroundColor: const Color(0xFF5931DD),
// //                       side: const BorderSide(color: Color(0xFF5931DD)),
// //                       padding: const EdgeInsets.symmetric(vertical: 12),
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(8),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ] else ...[
// //                 Expanded(
// //                   child: OutlinedButton.icon(
// //                     onPressed: _showImageSourceDialog,
// //                     icon: const Icon(Icons.edit),
// //                     label: const Text('Change Image'),
// //                     style: OutlinedButton.styleFrom(
// //                       foregroundColor: const Color(0xFF5931DD),
// //                       side: const BorderSide(color: Color(0xFF5931DD)),
// //                       padding: const EdgeInsets.symmetric(vertical: 12),
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(8),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //                 const SizedBox(width: 12),
// //                 Expanded(
// //                   child: ElevatedButton.icon(
// //                     onPressed: _isUploading ? null : _uploadImage,
// //                     icon: _isUploading
// //                         ? const SizedBox(
// //                             width: 16,
// //                             height: 16,
// //                             child: CircularProgressIndicator(
// //                               strokeWidth: 2,
// //                               color: Colors.white,
// //                             ),
// //                           )
// //                         : const Icon(Icons.cloud_upload),
// //                     label: Text(_isUploading ? 'Uploading...' : 'Upload'),
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: const Color(0xFF5931DD),
// //                       foregroundColor: Colors.white,
// //                       padding: const EdgeInsets.symmetric(vertical: 12),
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(8),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }












// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

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

// class _ImageUploadWidgetState extends State<ImageUploadWidget> with SingleTickerProviderStateMixin {
//   File? _selectedImage;
//   bool _isUploading = false;
//   final ImagePicker _picker = ImagePicker();
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 300),
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
//     );
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

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
//         _animationController.forward(from: 0.0);
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
//         _animationController.forward(from: 0.0);
//       }
//     } catch (e) {
//       _showErrorSnackbar('Failed to pick image: $e');
//     }
//   }

//   void _showImageSourceDialog() {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (BuildContext context) {
//         return Container(
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const SizedBox(height: 12),
//               Container(
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               const SizedBox(height: 24),
              
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 24),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Upload Delivery Proof',
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.w700,
//                         color: Color(0xFF1A1A1A),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     // Text(
//                     //   'Choose how you want to add the photo',
//                     //   style: TextStyle(
//                     //     fontSize: 14,
//                     //     color: Colors.grey[600],
//                     //     fontWeight: FontWeight.w400,
//                     //   ),
//                     // ),
//                   ],
//                 ),
//               ),
              
//               const SizedBox(height: 24),
              
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Column(
//                   children: [
//                     _buildSourceOption(
//                       icon: Icons.camera_alt_rounded,
//                       title: 'Take Photo',
//                       subtitle: 'Use camera to capture',
//                       gradient: const LinearGradient(
//                         colors: [Color(0xFF5931DD), Color(0xFF7B52E8)],
//                       ),
//                       onTap: () {
//                         Navigator.pop(context);
//                         _takePhoto();
//                       },
//                     ),
//                     // const SizedBox(height: 12),
//                     // _buildSourceOption(
//                     //   icon: Icons.photo_library_rounded,
//                     //   title: 'Choose from Gallery',
//                     //   subtitle: 'Select existing photo',
//                     //   gradient: LinearGradient(
//                     //     colors: [Colors.grey[700]!, Colors.grey[800]!],
//                     //   ),
//                     //   onTap: () {
//                     //     Navigator.pop(context);
//                     //     _pickFromGallery();
//                     //   },
//                     // ),
//                   ],
//                 ),
//               ),
              
//               const SizedBox(height: 24),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildSourceOption({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required Gradient gradient,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(16),
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.grey[50],
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: Colors.grey[200]!),
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 56,
//               height: 56,
//               decoration: BoxDecoration(
//                 gradient: gradient,
//                 borderRadius: BorderRadius.circular(14),
//               ),
//               child: Icon(
//                 icon,
//                 color: Colors.white,
//                 size: 28,
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: Color(0xFF1A1A1A),
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     subtitle,
//                     style: TextStyle(
//                       fontSize: 13,
//                       color: Colors.grey[600],
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Icon(
//               Icons.arrow_forward_ios_rounded,
//               size: 16,
//               color: Colors.grey[400],
//             ),
//           ],
//         ),
//       ),
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

//       request.files.add(
//         await http.MultipartFile.fromPath(
//           'image',
//           _selectedImage!.path,
//         ),
//       );

//       var streamedResponse = await request.send();
//       var response = await http.Response.fromStream(streamedResponse);

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final responseData = json.decode(response.body);
//         _showSuccessSnackbar('Image uploaded successfully!');
        
//         setState(() {
//           _selectedImage = null;
//         });

//         Navigator.pop(context);
        
//         print('Upload successful: $responseData');
//       } else {
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
//         content: Row(
//           children: [
//             const Icon(Icons.error_outline, color: Colors.white),
//             const SizedBox(width: 12),
//             Expanded(child: Text(message)),
//           ],
//         ),
//         backgroundColor: const Color(0xFFDC2626),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         margin: const EdgeInsets.all(16),
//         elevation: 6,
//       ),
//     );
//   }

//   void _showSuccessSnackbar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             const Icon(Icons.check_circle_outline, color: Colors.white),
//             const SizedBox(width: 12),
//             Expanded(child: Text(message)),
//           ],
//         ),
//         backgroundColor: const Color(0xFF059669),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         margin: const EdgeInsets.all(16),
//         elevation: 6,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             Colors.white,
//             Colors.grey[50]!,
//           ],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF5931DD).withOpacity(0.1),
//             blurRadius: 20,
//             offset: const Offset(0, 8),
//             spreadRadius: 0,
//           ),
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header Section
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   colors: [Color(0xFF5931DD), Color(0xFF7B52E8)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: const Color(0xFF5931DD).withOpacity(0.3),
//                     blurRadius: 8,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: const Icon(
//                       Icons.camera_alt_rounded,
//                       color: Colors.white,
//                       size: 24,
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           'Delivery Proof',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                             letterSpacing: 0.3,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         // Text(
//                         //   'Capture evidence of successful delivery',
//                         //   style: TextStyle(
//                         //     fontSize: 13,
//                         //     color: Colors.white.withOpacity(0.9),
//                         //     fontWeight: FontWeight.w400,
//                         //   ),
//                         // ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
            
//             // Content Section
//             Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 children: [
//                   // Image preview or placeholder
//                   GestureDetector(
//                     onTap: _selectedImage == null ? _showImageSourceDialog : null,
//                     child: AnimatedContainer(
//                       duration: const Duration(milliseconds: 300),
//                       width: double.infinity,
//                       height: 240,
//                       decoration: BoxDecoration(
//                         color: _selectedImage != null ? Colors.black : Colors.grey[100],
//                         borderRadius: BorderRadius.circular(16),
//                         border: Border.all(
//                           color: _selectedImage != null 
//                               ? const Color(0xFF5931DD).withOpacity(0.3)
//                               : Colors.grey[300]!,
//                           width: 2,
//                         ),
//                         boxShadow: _selectedImage != null
//                             ? [
//                                 BoxShadow(
//                                   color: const Color(0xFF5931DD).withOpacity(0.2),
//                                   blurRadius: 12,
//                                   offset: const Offset(0, 4),
//                                 ),
//                               ]
//                             : null,
//                       ),
//                       child: _selectedImage != null
//                           ? FadeTransition(
//                               opacity: _fadeAnimation,
//                               child: Stack(
//                                 children: [
//                                   ClipRRect(
//                                     borderRadius: BorderRadius.circular(14),
//                                     child: Image.file(
//                                       _selectedImage!,
//                                       width: double.infinity,
//                                       height: 240,
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                   Positioned(
//                                     top: 12,
//                                     right: 12,
//                                     child: Material(
//                                       color: Colors.transparent,
//                                       child: InkWell(
//                                         onTap: _removeImage,
//                                         borderRadius: BorderRadius.circular(20),
//                                         child: Container(
//                                           padding: const EdgeInsets.all(8),
//                                           decoration: BoxDecoration(
//                                             color: Colors.red[500],
//                                             shape: BoxShape.circle,
//                                             boxShadow: [
//                                               BoxShadow(
//                                                 color: Colors.red.withOpacity(0.4),
//                                                 blurRadius: 8,
//                                                 offset: const Offset(0, 2),
//                                               ),
//                                             ],
//                                           ),
//                                           child: const Icon(
//                                             Icons.close_rounded,
//                                             color: Colors.white,
//                                             size: 20,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   Positioned(
//                                     bottom: 12,
//                                     left: 12,
//                                     child: Container(
//                                       padding: const EdgeInsets.symmetric(
//                                         horizontal: 12,
//                                         vertical: 6,
//                                       ),
//                                       decoration: BoxDecoration(
//                                         color: Colors.black.withOpacity(0.6),
//                                         borderRadius: BorderRadius.circular(8),
//                                         border: Border.all(
//                                           color: Colors.white.withOpacity(0.2),
//                                         ),
//                                       ),
//                                       child: Row(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           Icon(
//                                             Icons.check_circle_rounded,
//                                             color: Colors.green[400],
//                                             size: 16,
//                                           ),
//                                           const SizedBox(width: 6),
//                                           const Text(
//                                             'Image Selected',
//                                             style: TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 12,
//                                               fontWeight: FontWeight.w600,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             )
//                           : Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Container(
//                                   padding: const EdgeInsets.all(20),
//                                   decoration: BoxDecoration(
//                                     color: const Color(0xFF5931DD).withOpacity(0.1),
//                                     shape: BoxShape.circle,
//                                   ),
//                                   child: Icon(
//                                     Icons.add_a_photo_rounded,
//                                     size: 48,
//                                     color: const Color(0xFF5931DD).withOpacity(0.6),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 16),
//                                 Text(
//                                   'Tap to Add Photo',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     color: Colors.grey[700],
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 // Text(
//                                 //   'Take a photo or choose from gallery',
//                                 //   style: TextStyle(
//                                 //     fontSize: 13,
//                                 //     color: Colors.grey[500],
//                                 //     fontWeight: FontWeight.w400,
//                                 //   ),
//                                 // ),
//                               ],
//                             ),
//                     ),
//                   ),
                  
//                   const SizedBox(height: 20),
                  
//                   // Action buttons
//                   if (_selectedImage == null)
//                     SizedBox(
//                       width: double.infinity,
//                       height: 54,
//                       child: ElevatedButton.icon(
//                         onPressed: _showImageSourceDialog,
//                         icon: const Icon(Icons.add_photo_alternate_rounded, size: 22),
//                         label: const Text(
//                           'Select Image',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF5931DD),
//                           foregroundColor: Colors.white,
//                           elevation: 4,
//                           shadowColor: const Color(0xFF5931DD).withOpacity(0.4),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(14),
//                           ),
//                         ),
//                       ),
//                     )
//                   else
//                     Row(
//                       children: [
//                         Expanded(
//                           flex: 2,
//                           child: SizedBox(
//                             height: 54,
//                             child: OutlinedButton.icon(
//                               onPressed: _showImageSourceDialog,
//                               // icon: const Icon(Icons.swap_horiz_rounded, size: 20),
//                               label: const Text(
//                                 'Change',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                               style: OutlinedButton.styleFrom(
//                                 foregroundColor: const Color(0xFF5931DD),
//                                 side: const BorderSide(
//                                   color: Color(0xFF5931DD),
//                                   width: 2,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(14),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           flex: 3,
//                           child: SizedBox(
//                             height: 54,
//                             child: ElevatedButton.icon(
//                               onPressed: _isUploading ? null : _uploadImage,
//                               icon: _isUploading
//                                   ? const SizedBox(
//                                       width: 20,
//                                       height: 20,
//                                       child: CircularProgressIndicator(
//                                         strokeWidth: 2.5,
//                                         color: Colors.white,
//                                       ),
//                                     )
//                                   : const Icon(Icons.cloud_upload_rounded, size: 22),
//                               label: Text(
//                                 _isUploading ? 'Uploading...' : 'Upload Photo',
//                                 style: const TextStyle(
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: const Color(0xFF5931DD),
//                                 foregroundColor: Colors.white,
//                                 elevation: 4,
//                                 shadowColor: const Color(0xFF5931DD).withOpacity(0.4),
//                                 disabledBackgroundColor: Colors.grey[400],
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(14),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }













import 'dart:io';
import 'dart:ui';
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

class _ImageUploadWidgetState extends State<ImageUploadWidget>
    with TickerProviderStateMixin {
  File? _selectedImage;
  bool _isUploading = false;
  final ImagePicker _picker = ImagePicker();

  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late AnimationController _slideController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.97, end: 1.03).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pulseController.dispose();
    _slideController.dispose();
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
        setState(() => _selectedImage = File(photo.path));
        _fadeController.forward(from: 0.0);
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
        setState(() => _selectedImage = File(image.path));
        _fadeController.forward(from: 0.0);
      }
    } catch (e) {
      _showErrorSnackbar('Failed to pick image: $e');
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0F0A1E).withOpacity(0.95),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                border: Border.all(
                  color: Colors.white.withOpacity(0.08),
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF6B35), Color(0xFFFF3CAC)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Add Delivery Photo',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.3,
                            ),
                          ),
                          Text(
                            'Capture or upload proof',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.45),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  _buildSheetOption(
                    icon: Icons.camera_alt_rounded,
                    title: 'Take a Photo',
                    subtitle: 'Open camera now',
                    startColor: const Color(0xFF7C3AED),
                    endColor: const Color(0xFFEC4899),
                    onTap: () {
                      Navigator.pop(context);
                      _takePhoto();
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildSheetOption(
                    icon: Icons.photo_library_rounded,
                    title: 'Choose from Gallery',
                    subtitle: 'Browse your photos',
                    startColor: const Color(0xFF0EA5E9),
                    endColor: const Color(0xFF6366F1),
                    onTap: () {
                      Navigator.pop(context);
                      _pickFromGallery();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSheetOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color startColor,
    required Color endColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.07), width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [startColor, endColor]),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: startColor.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.4),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Colors.white.withOpacity(0.4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) {
      _showErrorSnackbar('Please select an image first');
      return;
    }
    setState(() => _isUploading = true);
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'http://31.97.206.144:7021/api/rider/uploadDeliveryProof/${widget.userId}/${widget.orderId}'),
      );
      request.files.add(
        await http.MultipartFile.fromPath('image', _selectedImage!.path),
      );
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSuccessSnackbar('Delivery proof uploaded!');
        setState(() => _selectedImage = null);
        Navigator.pop(context);
      } else {
        final errorData = json.decode(response.body);
        _showErrorSnackbar('Upload failed: ${errorData['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      _showErrorSnackbar('Upload failed: $e');
    } finally {
      setState(() => _isUploading = false);
    }
  }

  void _removeImage() => setState(() => _selectedImage = null);

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [
        const Icon(Icons.error_outline_rounded, color: Colors.white, size: 20),
        const SizedBox(width: 10),
        Expanded(child: Text(message, style: const TextStyle(fontWeight: FontWeight.w500))),
      ]),
      backgroundColor: const Color(0xFFDC2626),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      margin: const EdgeInsets.all(16),
    ));
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [
        const Icon(Icons.check_circle_outline_rounded, color: Colors.white, size: 20),
        const SizedBox(width: 10),
        Expanded(child: Text(message, style: const TextStyle(fontWeight: FontWeight.w500))),
      ]),
      backgroundColor: const Color(0xFF059669),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      margin: const EdgeInsets.all(16),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0712),
      body: SlideTransition(
        position: _slideAnimation,
        child: CustomScrollView(
          slivers: [
            _buildAppBar(),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatusBadge(),
                    const SizedBox(height: 24),
                    _buildImageArea(),
                    const SizedBox(height: 20),
                    // _buildInfoCards(),
                    const SizedBox(height: 28),
                    _buildActionButtons(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 160,
      backgroundColor: Colors.transparent,
      pinned: true,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            // Deep dark gradient base
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1A0533),
                    Color(0xFF0F0A1E),
                  ],
                ),
              ),
            ),
            // Glow orb top-right
            Positioned(
              top: -40,
              right: -30,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFFF3CAC).withOpacity(0.25),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Glow orb left
            Positioned(
              bottom: 0,
              left: -20,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF7C3AED).withOpacity(0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Title content
            Positioned(
              bottom: 24,
              left: 20,
              right: 20,
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7C3AED), Color(0xFFEC4899)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7C3AED).withOpacity(0.5),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.verified_rounded, color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Delivery Proof',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        'Upload photo to confirm delivery',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.45),
                          fontWeight: FontWeight.w400,
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

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF7C3AED).withOpacity(0.15),
            const Color(0xFFEC4899).withOpacity(0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xFF7C3AED).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF10B981),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _selectedImage != null ? 'Photo ready to upload' : 'Awaiting photo',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.7),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageArea() {
    return GestureDetector(
      onTap: _selectedImage == null ? _showImageSourceDialog : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        width: double.infinity,
        height: 280,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _selectedImage != null
                ? const Color(0xFF7C3AED).withOpacity(0.6)
                : Colors.white.withOpacity(0.08),
            width: 1.5,
          ),
          boxShadow: _selectedImage != null
              ? [
                  BoxShadow(
                    color: const Color(0xFF7C3AED).withOpacity(0.3),
                    blurRadius: 24,
                    spreadRadius: -4,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(23),
          child: _selectedImage != null
              ? FadeTransition(
                  opacity: _fadeAnimation,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(
                        _selectedImage!,
                        fit: BoxFit.cover,
                      ),
                      // Dark gradient overlay bottom
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.65),
                              ],
                              stops: const [0.5, 1.0],
                            ),
                          ),
                        ),
                      ),
                      // Remove button
                      Positioned(
                        top: 14,
                        right: 14,
                        child: GestureDetector(
                          onTap: _removeImage,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.75),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.delete_outline_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Bottom status bar
                      Positioned(
                        bottom: 14,
                        left: 14,
                        right: 14,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.45),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.12),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF10B981).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.check_rounded,
                                      color: Color(0xFF10B981),
                                      size: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'Photo Selected',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: _showImageSourceDialog,
                                    child: Text(
                                      'Change',
                                      style: TextStyle(
                                        color: const Color(0xFFEC4899).withOpacity(0.9),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : _buildEmptyState(),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F0A1E),
        borderRadius: BorderRadius.circular(23),
      ),
      child: Stack(
        children: [
          // Background pattern dots
          Positioned.fill(
            child: CustomPaint(
              painter: _DotPatternPainter(),
            ),
          ),
          // Center content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7C3AED), Color(0xFFEC4899)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7C3AED).withOpacity(0.4),
                          blurRadius: 24,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.add_a_photo_rounded,
                      color: Colors.white,
                      size: 38,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Tap to Add Photo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Camera or gallery',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.35),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCards() {
    final items = [
      (Icons.flash_on_rounded, 'Fast Upload', const Color(0xFFFF6B35)),
      (Icons.lock_outline_rounded, 'Secure', const Color(0xFF7C3AED)),
      (Icons.hd_rounded, 'HD Quality', const Color(0xFF0EA5E9)),
    ];

    return Row(
      children: items.map((item) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(
              right: item == items.last ? 0 : 10,
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
            decoration: BoxDecoration(
              color: item.$3.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: item.$3.withOpacity(0.15),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Icon(item.$1, color: item.$3, size: 22),
                const SizedBox(height: 6),
                Text(
                  item.$2,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons() {
    if (_selectedImage == null) {
      return _buildPrimaryButton(
        label: 'Select Image',
        icon: Icons.add_photo_alternate_rounded,
        onTap: _showImageSourceDialog,
        gradient: const LinearGradient(
          colors: [Color(0xFF7C3AED), Color(0xFFEC4899)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        glowColor: const Color(0xFF7C3AED),
      );
    }

    return Column(
      children: [
        _buildPrimaryButton(
          label: _isUploading ? 'Uploading...' : 'Upload Photo',
          icon: _isUploading ? null : Icons.cloud_upload_rounded,
          isLoading: _isUploading,
          onTap: _isUploading ? null : _uploadImage,
          gradient: const LinearGradient(
            colors: [Color(0xFF7C3AED), Color(0xFFEC4899)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          glowColor: const Color(0xFF7C3AED),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 54,
          child: OutlinedButton.icon(
            onPressed: _showImageSourceDialog,
            icon: const Icon(Icons.swap_horiz_rounded, size: 20),
            label: const Text(
              'Change Photo',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white70,
              side: BorderSide(color: Colors.white.withOpacity(0.12), width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrimaryButton({
    required String label,
    IconData? icon,
    bool isLoading = false,
    VoidCallback? onTap,
    required Gradient gradient,
    required Color glowColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 58,
        decoration: BoxDecoration(
          gradient: onTap != null ? gradient : null,
          color: onTap == null ? Colors.grey[800] : null,
          borderRadius: BorderRadius.circular(18),
          boxShadow: onTap != null
              ? [
                  BoxShadow(
                    color: glowColor.withOpacity(0.45),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                    spreadRadius: -2,
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            else if (icon != null)
              Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..style = PaintingStyle.fill;

    const spacing = 24.0;
    for (double x = spacing; x < size.width; x += spacing) {
      for (double y = spacing; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}