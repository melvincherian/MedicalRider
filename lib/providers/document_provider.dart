import 'package:flutter/material.dart';
import 'package:medical_delivery_app/services/document_service.dart';
import 'package:medical_delivery_app/utils/helper_function.dart';

class DocumentProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _documents;

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic>? get documents => _documents;

  // Get driving license URL
  String? get drivingLicenseUrl => _documents?['drivingLicense'];

  // Check if documents exist
  bool get hasDocuments => _documents != null && _documents!.isNotEmpty;

  // Fetch documents for the current rider
  Future<void> fetchDocuments() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Get rider data from shared preferences
      final riderData = await SharedPreferenceService.getRiderData();
      if (riderData?.id == null) {
        _error = 'Rider ID not found';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Fetch documents from API
      final documents = await DocumentService.getDocuments(riderData!.id);
      
      if (documents != null) {
        _documents = documents;
        _error = null;
      } else {
        _error = 'Failed to load documents';
      }
    } catch (e) {
      _error = 'Error loading documents: $e';
      _documents = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Refresh documents
  Future<void> refreshDocuments() async {
    await fetchDocuments();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Clear all data
  void clearData() {
    _documents = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}