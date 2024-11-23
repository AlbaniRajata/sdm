import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sdm/models/user.dart';

class ApiService {
  final String _baseUrl = 'http://192.168.65.123:8000/api';

  Future<String> login(User user) async {
    final String apiUrl = '$_baseUrl/login';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData.containsKey('token')) {
        final token = responseData['token'];

        // Save JWT token in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', token);
        return 'Login successful';
      } else {
        return 'Failed to login: Token not found in response';
      }
    } else if (response.statusCode == 401) {
      final responseData = jsonDecode(response.body);
      if (responseData['error'] == 'Invalid username') {
        return 'Invalid username';
      } else if (responseData['error'] == 'Invalid password') {
        return 'Invalid password';
      } else {
        return 'Failed to login: ${responseData['error']}';
      }
    } else {
      try {
        final responseData = jsonDecode(response.body);
        return 'Failed to login: ${responseData['error']}';
      } catch (e) {
        return 'Failed to login: Unexpected error';
      }
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }

  Future<http.Response> getData(String apiUrl) async {
    final String fullUrl = '$_baseUrl$apiUrl';
    final token = await getToken();
    return await http.get(
      Uri.parse(fullUrl),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<http.Response> auth(Map<String, dynamic> data, String apiUrl) async {
    final String fullUrl = '$_baseUrl$apiUrl';
    return await http.post(
      Uri.parse(fullUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }
}
