import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sw_orders_app/view_models/auth_view_model.dart';
import 'package:sw_orders_app/view_models/orders_view_model.dart';
import 'package:sw_orders_app/views/auth_wrapper_view.dart';
import 'package:sw_orders_app/views/new_order_page_view.dart';

class OrdersPageView extends StatefulWidget {
  const OrdersPageView({super.key});

  @override
  State<OrdersPageView> createState() => _OrdersPageViewState();
}

class _OrdersPageViewState extends State<OrdersPageView> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      if (!mounted) return;

      final ordersViewModel = context.read<OrdersViewModel>();
      final authViewModel = context.read<AuthViewModel>();
      if (authViewModel.currentUser == null) {
        await authViewModel.refreshCurrentUser();
      }
      await ordersViewModel.fetchOrders(includeFinished: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ordersViewModel = context.watch<OrdersViewModel>();
    final authViewModel = context.watch<AuthViewModel>();

    final username = authViewModel.currentUser?.name ?? 'Usuário';

    return Scaffold(
      appBar: AppBar(
        title: Text('Olá, $username'),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NewOrderPageView()),
              );
            },

            label: const Text(
              'Novo pedido+',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (ordersViewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (ordersViewModel.error != null) {
            return Center(child: Text('Erro: ${ordersViewModel.error}'));
          }

          if (ordersViewModel.orders.isEmpty) {
            return const Center(child: Text('Nenhum pedido encontrado.'));
          }

          return ListView.builder(
            itemCount: ordersViewModel.orders.length,
            itemBuilder: (context, index) {
              final order = ordersViewModel.orders[index];
              final ordersVM = context.read<OrdersViewModel>();

              return ListTile(
                title: Text(order.description ?? 'Sem descrição'),
                subtitle: Text(
                  'Cliente: ${order.customerName ?? 'Desconhecido'}',
                ),
                trailing:
                    order.finished
                        ? const Icon(Icons.check, color: Colors.green)
                        : TextButton(
                          child: const Text('Finalizar'),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    title: const Text('Finalizar pedido'),
                                    content: const Text(
                                      'Tem certeza que deseja finalizar este pedido?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed:
                                            () => Navigator.pop(context, false),
                                        child: const Text('Cancelar'),
                                      ),
                                      TextButton(
                                        onPressed:
                                            () => Navigator.pop(context, true),
                                        child: const Text('Confirmar'),
                                      ),
                                    ],
                                  ),
                            );

                            if (confirm == true) {
                              await ordersVM.finishOrder(order.id);

                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Pedido finalizado'),
                                  ),
                                );
                              }
                            }
                          },
                        ),
              );
            },
          );
        },
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton.icon(
          icon: const Icon(Icons.logout),
          label: const Text('Logout'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
          ),
          onPressed: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder:
                  (context) => AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Tem certeza que deseja sair?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Sair'),
                      ),
                    ],
                  ),
            );
            if (confirmed == true) {
              if (!context.mounted) return;
              final authViewModel = context.read<AuthViewModel>();
              await authViewModel.logout();

              if (!context.mounted) return;

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const AuthWrapper()),
                (route) => false,
              );
            }
          },
        ),
      ),
    );
  }
}
