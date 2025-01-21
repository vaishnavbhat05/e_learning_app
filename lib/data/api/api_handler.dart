import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'endpoints.dart'; // Import Endpoints class

class ApiHandler {
  ApiHandler();

  Future<dynamic> getRequest(String endpoint, {Map<String, String>? headers}) async {
    try {
      String? accessToken = await _getAccessToken();
      headers ??= {};
      if (accessToken != null) {
        headers['Authorization'] = 'Bearer $accessToken';
      }

      // Use Endpoints.baseUrl instead of baseUrl
      final response = await http.get(Uri.parse('${Endpoints.baseUrl}$endpoint'), headers: headers);
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error during GET request: $e');
    }
  }

  Future<dynamic> postRequest(String endpoint, Map<String, dynamic> body, {Map<String, String>? headers}) async {
    try {
      String? accessToken = await _getAccessToken();
      headers ??= {'Content-Type': 'application/json'};
      if (accessToken != null) {
        headers['Authorization'] = 'Bearer $accessToken';
      }

      // Use Endpoints.baseUrl instead of baseUrl
      final response = await http.post(
        Uri.parse('${Endpoints.baseUrl}$endpoint'),
        headers: headers,
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error during POST request: $e');
    }
  }

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);
  }

  Future<String?> _getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<String?> _getRefreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('refresh_token');
  }

  Future<void> clearTokens() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode == 401) {
      throw Exception('Unauthorized - Please log in again.');
    }
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed with status code: ${response.statusCode}\n${response.body}');
    }
  }
}
