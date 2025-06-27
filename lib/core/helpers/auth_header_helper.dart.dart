import 'package:shared_preferences/shared_preferences.dart';

class AuthHeaderHelper {
  static Future<Map<String, String>> getJsonAuthHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    if (token == null) throw Exception('Token não encontrado');
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  static Map<String, String> getFormUrlEncodeHeaders() {
    return {'Content-Type': 'application/x-www-form-urlencoded'};
  }
}
