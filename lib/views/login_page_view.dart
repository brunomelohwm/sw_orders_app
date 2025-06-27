import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sw_orders_app/view_models/auth_view_model.dart';
import 'package:sw_orders_app/views/orders_page_view.dart';

class LoginPageView extends StatefulWidget {
  const LoginPageView({super.key});

  @override
  State<LoginPageView> createState() => _LoginPageViewState();
}

class _LoginPageViewState extends State<LoginPageView> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(labelText: 'Usuário'),
                      keyboardType: TextInputType.text,
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Informe o usuário'
                                  : null,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Senha'),
                      obscureText: true,
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Informe a senha'
                                  : null,
                    ),
                    const SizedBox(height: 40),
                    authViewModel.isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              authViewModel.setUsername(
                                _usernameController.text,
                              );
                              authViewModel.setPassword(
                                _passwordController.text,
                              );

                              final success = await authViewModel.login();

                              if (!context.mounted) return;

                              if (success) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const OrdersPageView(),
                                  ),
                                );
                              } else {
                                final error =
                                    authViewModel.errorMessage ??
                                    'Erro desconhecido';

                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(SnackBar(content: Text(error)));
                              }
                            }
                          },
                          child: const Text('Entrar'),
                        ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
