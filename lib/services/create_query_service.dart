import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medical_delivery_app/constants/api_constant.dart';
import 'package:medical_delivery_app/models/query_model.dart';

class CreateQueryService {
  static Future<QueryResponse> createQuery(QueryModel query) async {
    try {
      final url = Uri.parse('${ApiConstant.baseUrl}${ApiConstant.createQuery}');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(query.toJson()),
      );


      print('response status code for queryyyyyyyyyyyyyyyyyyyyyyyyyy${response.statusCode}');
            print('response status bodyyyyyyyyyyyyyyyyyyyyyyyy${response.body}');


      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return QueryResponse.fromJson(responseData);
      } else {
        throw Exception('Failed to create query: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating query: $e');
    }
  }
}
