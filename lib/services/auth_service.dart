import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sw_orders_app/core/helpers/error_helper.dart';
import 'package:sw_orders_app/core/utils/url_constants.dart';
import 'package:sw_orders_app/models/token_response_model.dart';
import 'package:sw_orders_app/core/helpers/auth_header_helper.dart.dart';

class AuthService {
  final uri = Uri.parse(UrlConstants.tokenEndpoint);

  Future<TokenResponseModel> login(String username, String password) async {
    return _postTokenRequest({
      'grant_type': 'password',
      'client_id': 'user',
      'username': username,
      'password': password,
      'scope': 'offline_access user',
    });
  }

  Future<TokenResponseModel> refreshToken(String refreshToken) async {
    return _postTokenRequest({
      'grant_type': 'refresh_token',
      'client_id': 'user',
      'refresh_token': refreshToken,
    });
  }

  Future<TokenResponseModel> _postTokenRequest(Map<String, String> body) async {
    try {
      final response = await http.post(
        uri,
        headers: AuthHeaderHelper.getFormUrlEncodeHeaders(),
        body: body,
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return TokenResponseModel.fromJson(json);
      } else {
        final errorMessage = ErrorHelper.getErrorMessage(
          'Erro ao autenticar: ${response.statusCode}',
        );
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception(ErrorHelper.getErrorMessage(e));
    }
  }
}
