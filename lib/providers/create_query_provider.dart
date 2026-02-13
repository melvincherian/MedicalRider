import 'package:flutter/material.dart';
import 'package:medical_delivery_app/models/query_model.dart';
import 'package:medical_delivery_app/services/create_query_service.dart';

class CreateQueryProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  QueryResponse? _queryResponse;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  QueryResponse? get queryResponse => _queryResponse;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearForm() {
    nameController.clear();
    emailController.clear();
    mobileController.clear();
    messageController.clear();
    _queryResponse = null;
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> submitQuery(String riderId) async {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final query = QueryModel(
        riderId: riderId,
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        mobile: mobileController.text.trim(),
        message: messageController.text.trim(),
      );

      _queryResponse = await CreateQueryService.createQuery(query);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    messageController.dispose();
    super.dispose();
  }
}