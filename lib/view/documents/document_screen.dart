import 'package:flutter/material.dart';
import 'package:medical_delivery_app/view/documents/document_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:medical_delivery_app/providers/document_provider.dart';

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({super.key});

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Load documents when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DocumentProvider>().fetchDocuments();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Documents",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: Consumer<DocumentProvider>(
        builder: (context, documentProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Search bar
                TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Search documents...",
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Content based on state
                Expanded(
                  child: _buildContent(documentProvider),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(DocumentProvider provider) {
    if (provider.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.teal),
            SizedBox(height: 16),
            Text('Loading documents...', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    if (provider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              provider.error!,
              style: const TextStyle(color: Colors.red, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => provider.refreshDocuments(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (!provider.hasDocuments) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.description, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No documents found',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    // Build document list
    List<Widget> documentCards = [];
    
    // Add driving license if available and matches search
    if (provider.drivingLicenseUrl != null &&
        ('driving license'.contains(_searchQuery) || _searchQuery.isEmpty)) {
      documentCards.add(_buildDocumentCard(
        title: "Driving License",
        subtitle: "Click to view document",
        color: Colors.blue.shade100,
        icon: Icons.badge,
        imageUrl: provider.drivingLicenseUrl,
        onTap: () => _navigateToDocumentDetail(
          "Driving License",
          provider.drivingLicenseUrl,
        ),
      ));
    }

    // Add other documents here in the future...

    if (documentCards.isEmpty && _searchQuery.isNotEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No documents match your search',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => provider.refreshDocuments(),
      child: ListView(
        children: documentCards,
      ),
    );
  }

  Widget _buildDocumentCard({
    required String title,
    required String subtitle,
    required Color color,
    required IconData icon,
    String? imageUrl,
    VoidCallback? onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: color,
          child: Icon(icon, color: Colors.black87, size: 28),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle),
            if (imageUrl != null)
              const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'Document available',
                    style: TextStyle(color: Colors.green, fontSize: 12),
                  ),
                ],
              )
            else
              const Row(
                children: [
                  Icon(Icons.error, color: Colors.orange, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'Document not uploaded',
                    style: TextStyle(color: Colors.orange, fontSize: 12),
                  ),
                ],
              ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios, size: 18),
          onPressed: onTap,
        ),
        onTap: onTap,
      ),
    );
  }

  void _navigateToDocumentDetail(String title, String? imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DocumentDetailScreen(
          title: title,
          imageUrl: imageUrl,
        ),
      ),
    );
  }
}