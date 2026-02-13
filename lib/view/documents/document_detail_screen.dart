import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DocumentDetailScreen extends StatelessWidget {
  final String title;
  final String? imageUrl;

  const DocumentDetailScreen({
    super.key,
    required this.title,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Center(
        child: imageUrl != null
            ? InteractiveViewer(
                child: CachedNetworkImage(
                  imageUrl: imageUrl!,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                  errorWidget: (context, url, error) => const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, color: Colors.red, size: 64),
                      SizedBox(height: 16),
                      Text(
                        'Failed to load image',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              )
            : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.description, color: Colors.grey, size: 64),
                  SizedBox(height: 16),
                  Text(
                    'No document available',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
      ),
    );
  }
}