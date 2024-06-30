// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, unused_import

import 'package:flutter/material.dart';
import 'package:kasuwa/screens/auth/views/payment_screen.dart';

class ShoppingCartScreen extends StatefulWidget {
  @override
  _ShoppingCartScreenState createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  List<CartItem> cartItems = [
    CartItem(
      name: 'Banana',
      price: 100.00,
      quantity: 1,
      imageAsset: const AssetImage('images/banana.png'),
    ),
    CartItem(
      name: 'Apple',
      price: 500.00,
      quantity: 1,
      imageAsset: const AssetImage('images/apple.jpg'),
    ),
    CartItem(
      name: 'Pineapple',
      price: 800.00,
      quantity: 1,
      imageAsset: const AssetImage('images/banana.png'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0.0,
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_cart_outlined,
                color: Theme.of(context).colorScheme.primary,
                size: 28.0,
              ),
              const SizedBox(width: 8.0),
              Text('Shopping Cart',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 24.0,
                  )),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  return CartItemWidget(
                    cartItem: cartItems[index],
                    onDelete: () {
                      setState(() {
                        cartItems.removeAt(index);
                      });
                    },
                    onQuantityChanged: (newQuantity) {
                      setState(() {
                        cartItems[index].quantity = newQuantity;
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),
            const Divider(),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: \rrwf ${getTotalPrice().toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PaymentMethodsScreen()));
                  },
                  child: const Text('Checkout'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  double getTotalPrice() {
    double total = 0.0;
    for (var item in cartItems) {
      total += item.price * item.quantity;
    }
    return total;
  }
}

class CartItem {
  final String name;
  final double price;
  int quantity;
  final AssetImage imageAsset;

  CartItem({
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageAsset,
  });
}

class CartItemWidget extends StatefulWidget {
  final CartItem cartItem;
  final VoidCallback onDelete;
  final Function(int) onQuantityChanged;

  const CartItemWidget({
    required this.cartItem,
    required this.onDelete,
    required this.onQuantityChanged,
  });

  @override
  _CartItemWidgetState createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.cartItem.name),
      onDismissed: (direction) {
        widget.onDelete();
      },
      background: Container(
        color: Theme.of(context).colorScheme.primary,
        child: const Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ),
      ),
      direction: DismissDirection.endToStart,
      resizeDuration: const Duration(milliseconds: 200),
      dismissThresholds: const {
        DismissDirection.endToStart: 0.5,
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        decoration: BoxDecoration(
          // color: Theme.of(context).colorScheme.tertiary.withOpacity(0.3),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            // width: 3.0,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              widget.cartItem.imageAsset.assetName,
              width: 50.0,
              height: 50.0,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.cartItem.name,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '\rrwf ${(widget.cartItem.price * widget.cartItem.quantity).toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      widget.cartItem.quantity++;
                      widget.onQuantityChanged(widget.cartItem.quantity);
                    });
                  },
                  icon: Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(
                  '${widget.cartItem.quantity}',
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (widget.cartItem.quantity > 1) {
                        widget.cartItem.quantity--;
                        widget.onQuantityChanged(widget.cartItem.quantity);
                      }
                    });
                  },
                  icon: Icon(
                    Icons.remove,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
