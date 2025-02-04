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

      final response = await http.get(Uri.parse('${Endpoints.baseUrl}$endpoint'), headers: headers);

      // If unauthorized (401), attempt to refresh the access token and retry the request
      if (response.statusCode == 401) {
        accessToken = await _refreshAccessToken();
        if (accessToken != null) {
          headers['Authorization'] = 'Bearer $accessToken';
          final retryResponse = await http.get(Uri.parse('${Endpoints.baseUrl}$endpoint'), headers: headers);
          return _handleResponse(retryResponse);
        }
      }

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

      final response = await http.post(
        Uri.parse('${Endpoints.baseUrl}$endpoint'),
        headers: headers,
        body: jsonEncode(body),
      );

      // If unauthorized (401), attempt to refresh the access token and retry the request
      if (response.statusCode == 401) {
        accessToken = await _refreshAccessToken();
        if (accessToken != null) {
          headers['Authorization'] = 'Bearer $accessToken';
          final retryResponse = await http.post(
            Uri.parse('${Endpoints.baseUrl}$endpoint'),
            headers: headers,
            body: jsonEncode(body),
          );
          return _handleResponse(retryResponse);
        }
      }

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error during POST request: $e');
    }
  }

  Future<dynamic> putRequest(String endpoint ,Map<String, dynamic> body, {Map<String, String>? headers}) async {
    try {
      String? accessToken = await _getAccessToken();
      headers ??= {'Content-Type': 'application/json'};
      if (accessToken != null) {
        headers['Authorization'] = 'Bearer $accessToken';
      }

      final response = await http.put(
        Uri.parse('${Endpoints.baseUrl}$endpoint'),
        headers: headers,
        body: jsonEncode(body),
      );

      // If unauthorized (401), attempt to refresh the access token and retry the request
      if (response.statusCode == 401) {
        accessToken = await _refreshAccessToken();
        if (accessToken != null) {
          headers['Authorization'] = 'Bearer $accessToken';
          final retryResponse = await http.put(
            Uri.parse('${Endpoints.baseUrl}$endpoint'),
            headers: headers,
          );
          return _handleResponse(retryResponse);
        }
      }

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error during PUT request: $e');
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

  Future<String?> _refreshAccessToken() async {
    try {
      String? refreshToken = await _getRefreshToken();
      if (refreshToken == null) {
        throw Exception('Refresh token not found. Please log in again.');
      }

      // Request to refresh the access token
      final response = await http.post(
        Uri.parse('${Endpoints.baseUrl}/refresh-token'), // Adjust the endpoint to your API's refresh token endpoint
        body: {'refresh_token': refreshToken},
      );

      // If the refresh token request is successful, save the new access token
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String newAccessToken = data['access_token'];
        String newRefreshToken = data['refresh_token']; // Optional: if the refresh token is also updated
        await saveTokens(newAccessToken, newRefreshToken);
        return newAccessToken;
      } else {
        throw Exception('Failed to refresh token');
      }
    } catch (e) {
      throw Exception('Error refreshing access token: $e');
    }
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

    if (response.statusCode == 400) {
      final errorData = jsonDecode(response.body);
      throw Exception('Bad Request: ${errorData['message'] ?? 'Invalid request parameters'}');
    }

    if (response.statusCode == 403) {
      final errorData = jsonDecode(response.body);
      throw Exception('Forbidden: ${errorData['message'] ?? 'You do not have permission to access this resource'}');
    }

    if (response.statusCode == 404) {
      final errorData = jsonDecode(response.body);
      throw Exception('Not Found: ${errorData['message'] ?? 'Resource not found'}');
    }

    if (response.statusCode == 500) {
      final errorData = jsonDecode(response.body);
      throw Exception('Internal Server Error: ${errorData['message'] ?? 'Something went wrong on the server'}');
    }

    if (response.statusCode == 502) {
      final errorData = jsonDecode(response.body);
      throw Exception('Bad Gateway: ${errorData['message'] ?? 'Invalid response from upstream server'}');
    }

    if (response.statusCode == 503) {
      final errorData = jsonDecode(response.body);
      throw Exception('Service Unavailable: ${errorData['message'] ?? 'The server is temporarily unavailable'}');
    }

    if (response.statusCode == 504) {
      final errorData = jsonDecode(response.body);
      throw Exception('Gateway Timeout: ${errorData['message'] ?? 'The request timed out while waiting for a response'}');
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    }

    throw Exception('Failed with status code: ${response.statusCode}\n${response.body}');
  }

}
