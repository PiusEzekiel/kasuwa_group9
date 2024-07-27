import 'package:flutter/material.dart';
import 'package:kasuwa/blocs/cart_bloc/bloc/cart_bloc.dart';
import 'package:kasuwa/screens/cart/models/cart_item.dart';
import 'package:kasuwa/screens/cart/views/payment_option.dart';
import 'package:provider/provider.dart'; // Import provider

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(LoadCartEvent()); // Dispatch LoadCartEvent
  }

  @override
  Widget build(BuildContext context) {
    // Access the CartBloc using Provider.of
    // final cartBloc = Provider.of<CartBloc>(context);
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.of(context).pop();
        //   },
        // ),
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
              Text('Shopping Cart       ',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 24.0,
                  )),
            ],
          ),
        ),
      ),
      body: Consumer<CartBloc>(
        builder: (context, cartBloc, child) {
          if (cartBloc.state is CartLoaded) {
            final cartState = cartBloc.state as CartLoaded;
            if (cartState.cartItems.isEmpty) {
              return const Center(child: Text("Cart is empty"));
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartState.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartState.cartItems[index];
                      return CartItemWidget(cartItem: item);
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                      bottom: 40.0, top: 20, right: 25, left: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16.0),
                      Divider(
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total: RWF ${cartState.totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                              // shape: RoundedRectangleBorder(
                              //   borderRadius: BorderRadius.circular(8.0),
                              // ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PaymentMethodsScreen()));
                            },
                            child: const Text('Checkout',
                                style: TextStyle(fontSize: 16)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (cartBloc.state is CartError) {
            return Center(child: Text((cartBloc.state as CartError).message));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class CartItemWidget extends StatefulWidget {
  final CartItem cartItem;

  const CartItemWidget({super.key, required this.cartItem});

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          // height: MediaQuery.of(context).size.height * 0.80, // 80% of Screen
          child: Padding(
            padding: const EdgeInsets.only(
                top: 8.0, right: 15.0, left: 15.0, bottom: 0.0),
            child: Card(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10),
                child: ListTile(
                  //product image
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.network(widget.cartItem.imageUrl),
                  ),
                  //product name
                  title: Text(
                    widget.cartItem.name,
                    style: const TextStyle(
                      fontSize: 17.0,
                    ),
                  ),
                  //product price
                  subtitle: Text(
                    'RWF ${widget.cartItem.getTotalPrice().toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 15.0,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  //product quantity
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Remove from cart
                      IconButton(
                        onPressed: () {
                          context.read<CartBloc>().add(
                                RemoveFromCartEvent(cartItem: widget.cartItem),
                              );
                        },
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                      // Decrease quantity
                      IconButton(
                        onPressed: () {
                          if (widget.cartItem.quantity > 1) {
                            context.read<CartBloc>().add(
                                  UpdateCartQuantityEvent(
                                    cartItem: widget.cartItem,
                                    quantity: widget.cartItem.quantity - 1,
                                  ),
                                );
                          }
                        },
                        icon: Icon(Icons.remove,
                            color: Theme.of(context).colorScheme.secondary),
                      ),

                      // const SizedBox(width: 8),
                      // Quantity
                      Text('${widget.cartItem.quantity}',
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Theme.of(context).colorScheme.primary)),
                      // const SizedBox(height: 1),
                      // Increase quantity
                      IconButton(
                        onPressed: () {
                          context.read<CartBloc>().add(
                                UpdateCartQuantityEvent(
                                  cartItem: widget.cartItem,
                                  quantity: widget.cartItem.quantity + 1,
                                ),
                              );
                        },
                        icon: Icon(Icons.add,
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
