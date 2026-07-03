import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../configs/constants.dart';
import '../configs/generic_response.dart';

class AuthService {
  Future<GenericResponse<Map<String, dynamic>>> login(
      String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/apis/v1/users/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      final json = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && json['success'] == true) {
        final data = json['data'] as Map<String, dynamic>;
        final token = data['jwt'] as String;
        final userDict = data['user'] as Map<String, dynamic>;
        
        // Save token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setString('user_name', userDict['first_name'] ?? '');

        return GenericResponse.fromJson(
          json,
          fromJsonT: (d) => d as Map<String, dynamic>,
        );
      } else {
        return GenericResponse(
          success: false,
          message: json['message'] ?? 'Error de autenticación',
          error: json['error'],
        );
      }
    } catch (e) {
      return GenericResponse(
        success: false,
        message: 'Error de conexión',
        error: e.toString(),
      );
    }
  }
}
