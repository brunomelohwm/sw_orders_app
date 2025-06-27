import 'dart:convert';
import 'package:sw_orders_app/core/network/http_client_with_auth.dart';
import 'package:sw_orders_app/core/utils/url_constants.dart';
import 'package:sw_orders_app/models/user_model.dart';

class UserService {
  final HttpClientWithAuth _client;

  UserService(this._client);

  Future<UserModel> getCurrentUser(String token) async {
    final uri = Uri.parse(UrlConstants.currentUserEndpoint);

    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return UserModel.fromJson(json);
    } else {
      throw Exception('Erro ao obter dados do usuário: ${response.statusCode}');
    }
  }
}
