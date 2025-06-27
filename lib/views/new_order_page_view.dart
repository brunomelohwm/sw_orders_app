import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sw_orders_app/view_models/orders_view_model.dart';

class NewOrderPageView extends StatefulWidget {
  const NewOrderPageView({super.key});

  @override
  State<NewOrderPageView> createState() => _NewOrderPageViewState();
}

class _NewOrderPageViewState extends State<NewOrderPageView> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _customerNameController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    _customerNameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final viewModel = context.read<OrdersViewModel>();

      await viewModel.createOrder(
        _descriptionController.text.trim(),
        _customerNameController.text.trim().isEmpty
            ? null
            : _customerNameController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pedido criado com sucesso')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OrdersViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Novo Pedido')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator:
                    (value) =>
                        value == null || value.trim().isEmpty
                            ? 'Obrigatório'
                            : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _customerNameController,
                decoration: const InputDecoration(
                  labelText: 'Cliente (opcional)',
                ),
              ),
              const SizedBox(height: 24),
              viewModel.isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                    onPressed: viewModel.isLoading ? null : _submit,
                    child: const Text('Criar Pedido'),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
