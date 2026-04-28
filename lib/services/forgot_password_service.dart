import 'dart:convert';
import 'package:http/http.dart' as http;

class ForgotPasswordService {
  static const String baseUrl = 'https://api.simcurarx.com/';
  static const String forgotPasswordEndpoint = 'api/rider/forgot-password';

  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$forgotPasswordEndpoint');

      final payload = {
        "email": email,
        "newPassword": newPassword,
        "confirmPassword": confirmPassword,
      };

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload),
      );

      final responseData = json.decode(response.body);

      print('reset password response status code ${response.statusCode}');
      print('reset password response bodyyyyy ${response.body}');

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': responseData['message'] ?? 'Password reset successfully',
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Password reset failed',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }
}
