import 'package:flutter/material.dart';
import 'package:medical_delivery_app/models/login_model.dart';
import 'package:medical_delivery_app/services/login_service.dart';
import 'package:medical_delivery_app/utils/helper_function.dart';

enum LoginState { initial, loading, success, error }

class LoginProvider extends ChangeNotifier {
  LoginState _loginState = LoginState.initial;
  String _errorMessage = '';
  RiderModel? _rider;

  LoginState get loginState => _loginState;
  String get errorMessage => _errorMessage;
  RiderModel? get rider => _rider;

  Future<bool> login(BuildContext context, String phone, String password) async {
    _loginState = LoginState.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final loginResponse = await LoginService.login(context,phone, password);
      
      if (loginResponse != null) {
        _rider = loginResponse.rider;
        
        // Save to shared preferences
        await SharedPreferenceService.saveRiderData(_rider!);
        await SharedPreferenceService.setLoginStatus(true);
        
        _loginState = LoginState.success;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Login failed';
        _loginState = LoginState.error;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _loginState = LoginState.error;
      notifyListeners();
      return false;
    }
  }

  Future<void> loadSavedRiderData() async {
    try {
      final savedRider = await SharedPreferenceService.getRiderData();
      final isLoggedIn = await SharedPreferenceService.getLoginStatus();
      
      if (savedRider != null && isLoggedIn) {
        _rider = savedRider;
        _loginState = LoginState.success;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to load saved data';
      _loginState = LoginState.error;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      await SharedPreferenceService.clearAllData();
      _rider = null;
      _loginState = LoginState.initial;
      _errorMessage = '';
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Logout failed';
      notifyListeners();
    }
  }
  

  void clearError() {
    _errorMessage = '';
    if (_loginState == LoginState.error) {
      _loginState = LoginState.initial;
      notifyListeners();
    }
  }
}