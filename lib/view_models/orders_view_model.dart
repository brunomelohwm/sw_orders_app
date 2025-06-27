import 'package:flutter/foundation.dart';
import 'package:sw_orders_app/core/helpers/error_helper.dart';
import 'package:sw_orders_app/models/order_model.dart';
import 'package:sw_orders_app/services/order_service.dart';

class OrdersViewModel extends ChangeNotifier {
  final OrderService _orderService;

  OrdersViewModel(this._orderService);

  List<OrderModel> _orders = [];
  bool _isLoading = false;
  String? _error;

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchOrders({bool includeFinished = false}) async {
    _isLoading = true;
    _error = null;

    try {
      _orders = await _orderService.getOrders(includeFinished: includeFinished);
    } catch (e) {
      _error = ErrorHelper.getErrorMessage(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createOrder(String description, String? customerName) async {
    _isLoading = true;

    try {
      await _orderService.createOrder(description, customerName);
      await fetchOrders(includeFinished: true);
    } catch (e) {
      _error = ErrorHelper.getErrorMessage(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> finishOrder(String orderId) async {
    _isLoading = true;

    try {
      await _orderService.finishOrder(orderId);
      await fetchOrders(includeFinished: true);
    } catch (e) {
      _error = ErrorHelper.getErrorMessage(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
