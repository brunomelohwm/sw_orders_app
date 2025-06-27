import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sw_orders_app/core/helpers/auth_header_helper.dart.dart';
import 'package:sw_orders_app/services/auth_service.dart';

class HttpClientWithAuth {
  final AuthService _authService;

  HttpClientWithAuth(this._authService);

  Future<http.Response> get(Uri url) async {
    return _sendWithAuth(
      () async => await http.get(
        url,
        headers: await AuthHeaderHelper.getJsonAuthHeaders(),
      ),
    );
  }

  Future<http.Response> post(Uri url, {Object? body}) async {
    return _sendWithAuth(
      () async => await http.post(
        url,
        headers: await AuthHeaderHelper.getJsonAuthHeaders(),
        body: jsonEncode(body),
      ),
    );
  }

  Future<http.Response> put(Uri url, {Object? body}) async {
    return _sendWithAuth(
      () async => await http.put(
        url,
        headers: await AuthHeaderHelper.getJsonAuthHeaders(),
        body: jsonEncode(body),
      ),
    );
  }

  Future<http.Response> _sendWithAuth(
    Future<http.Response> Function() authenticatedRequest,
  ) async {
    var response = await authenticatedRequest();

    if (response.statusCode == 401) {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('refresh_token');

      if (refreshToken != null) {
        try {
          final newToken = await _authService.refreshToken(refreshToken);
          await prefs.setString('access_token', newToken.accessToken);
          await prefs.setString('refresh_token', newToken.refreshToken);

          response = await authenticatedRequest();
        } catch (e) {
          throw Exception('Sessão expirada. Faça login novamente.');
        }
      } else {
        throw Exception('Token expirado e nenhum refresh token disponível.');
      }
    }

    return response;
  }
}
