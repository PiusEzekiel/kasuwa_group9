import 'package:flutter/material.dart';
import 'package:kasuwa_repository/kasuwa_repository.dart';

import '/models/cart_item.dart';

class CartScreen extends StatelessWidget {
  final List<CartItem> cartItems;

  const CartScreen({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: cartItems.isEmpty
          ? Center(
              child: Text('Your cart is empty.'),
            )
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final cartItem = cartItems[index];
                return ListTile(
                  leading: Image.network(cartItem.kasuwa.picture),
                  title: Text(cartItem.kasuwa.name),
                  subtitle: Text('Quantity: ${cartItem.quantity}'),
                  trailing: Text(
                    'RWF ${cartItem.totalPrice}.00',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
      bottomNavigationBar: cartItems.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Handle checkout logic here
                },
                child: const Text('Checkout'),
              ),
            )
          : null,
    );
  }
}
