import 'dart:convert';
import 'package:sw_orders_app/core/network/http_client_with_auth.dart';
import 'package:sw_orders_app/core/utils/url_constants.dart';
import 'package:sw_orders_app/models/order_model.dart';

class OrderService {
  final HttpClientWithAuth _client;

  OrderService(this._client);

  Future<List<OrderModel>> getOrders({bool includeFinished = false}) async {
    final uri = Uri.parse(
      '${UrlConstants.ordersEndpoint}?includeFinished=$includeFinished',
    );

    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => OrderModel.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar pedidos: ${response.statusCode}');
    }
  }

  Future<void> createOrder(String description, String? customerName) async {
    final uri = Uri.parse(UrlConstants.ordersEndpoint);

    final body = {'description': description, 'customerName': customerName};

    final response = await _client.post(uri, body: body);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Erro ao criar pedido: ${response.statusCode}');
    }
  }

  Future<void> finishOrder(String orderId) async {
    final uri = Uri.parse('${UrlConstants.ordersEndpoint}/$orderId/finish');

    final response = await _client.put(uri);

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Erro ao finalizar pedido: ${response.statusCode}');
    }
  }
}
