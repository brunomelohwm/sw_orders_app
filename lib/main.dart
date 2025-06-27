import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sw_orders_app/core/network/http_client_with_auth.dart';
import 'package:sw_orders_app/services/auth_service.dart';
import 'package:sw_orders_app/services/order_service.dart';
import 'package:sw_orders_app/services/user_service.dart';
import 'package:sw_orders_app/view_models/auth_view_model.dart';
import 'package:sw_orders_app/view_models/orders_view_model.dart';
import 'package:sw_orders_app/views/auth_wrapper_view.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),

        ProxyProvider<AuthService, HttpClientWithAuth>(
          update: (_, authService, __) => HttpClientWithAuth(authService),
        ),

        ProxyProvider<HttpClientWithAuth, OrderService>(
          update: (_, client, __) => OrderService(client),
        ),

        ProxyProvider<HttpClientWithAuth, UserService>(
          update: (_, client, __) => UserService(client),
        ),

        ChangeNotifierProvider<AuthViewModel>(
          create:
              (context) => AuthViewModel(
                context.read<AuthService>(),
                context.read<UserService>(),
              ),
        ),

        ChangeNotifierProvider<OrdersViewModel>(
          create: (context) => OrdersViewModel(context.read<OrderService>()),
        ),
      ],

      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SW Orders App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const AuthWrapper(),
    );
  }
}
