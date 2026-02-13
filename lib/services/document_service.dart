import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medical_delivery_app/constants/api_constant.dart';

class DocumentService {
  // Get documents for a rider
  static Future<Map<String, dynamic>?> getDocuments(String riderId) async {
    try {
      final url = ApiConstant.documents(riderId);
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );


        print('documents status codeee ${response.statusCode}');
                print('documents bodyyyyyyyyyy ${response.body}');



      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception in getDocuments: $e');
      return null;
    }
  }

  // Upload document (if needed in future)
  // static Future<bool> uploadDocument(String riderId, String documentType, String filePath) async {
  //   try {
  //     final url = ApiConstant.documents(riderId);
  //     var request = http.MultipartRequest('POST', Uri.parse(url));
      
  //     // Add the file
  //     request.files.add(await http.MultipartFile.fromPath(documentType, filePath));
  //     request.fields['riderId'] = riderId;
      
  //     var response = await request.send();
      
  //     if (response.statusCode == 200) {
  //       return true;
  //     } else {
  //       print('Upload failed: ${response.statusCode}');
  //       return false;
  //     }
  //   } catch (e) {
  //     print('Exception in uploadDocument: $e');
  //     return false;
  //   }
  // }
}