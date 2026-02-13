
import 'package:flutter/material.dart';
import 'package:medical_delivery_app/home/navbar_screen.dart';
import 'package:medical_delivery_app/widget/image_upload_widget.dart';

class ImageShowingScreen extends StatefulWidget {
  final String? userid;
  final String? orderId;
  const ImageShowingScreen({super.key, this.orderId, this.userid});

  @override
  State<ImageShowingScreen> createState() => _ImageShowingScreenState();
}

class _ImageShowingScreenState extends State<ImageShowingScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Delivery Proof'),
        backgroundColor: const Color(0xFF5931DD),
        foregroundColor: Colors.white,
        leading: IconButton(onPressed: (){
          Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const NavbarScreen()),
      (Route<dynamic> route) => false, 
    );
        }, icon: Icon(Icons.arrow_back_ios)),
      ),
      body: Column(
        children: [
          ImageUploadWidget(
            userId: widget.userid.toString(),
            orderId: widget.orderId.toString(),
            onUploadSuccess: () {
              print('Image uploaded successfully for order: ${widget.orderId}');
              
            },
          ),
        ],
      ),
    );
  }
}