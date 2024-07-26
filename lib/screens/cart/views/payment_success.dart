import 'package:flutter/material.dart';
import 'package:kasuwa/blocs/cart_bloc/bloc/cart_bloc.dart';
import 'package:kasuwa/screens/cart/models/cart_item.dart';
// import 'package:kasuwa/screens/cart/views/order_history';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ... other imports

class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen({super.key});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  late ConfettiController _confettiController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 5));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _saveOrderToFirebase(List<CartItem> cartItems) async {
    final user = _auth.currentUser;
    final timestamp = DateTime.now();

    if (user != null) {
      final orderRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('orders')
          .doc(timestamp.toString());

      final orderData = {
        // 'order_id': orderRef.id,
        'order_id': timestamp,
        'items': cartItems
            .map((item) => {
                  'name': item.name,
                  'quantity': item.quantity,
                  'price': item.discount,
                })
            .toList(),
        'total_price': cartItems.fold<double>(
            0, (total, item) => total + item.getTotalPrice()),
        'timestamp': timestamp,
      };

      await orderRef.set(orderData);
    } else {
      // Handle case where user is not logged in
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartBloc = Provider.of<CartBloc>(context);

    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back),
      //     onPressed: () {
      //       cartBloc.add(ClearCartEvent());
      //                     _saveOrderToFirebase(cartState.cartItems);
      //                     Navigator.popUntil(context, (route) => route.isFirst);
      //     },
      //   ),
      // ),
      body: Consumer<CartBloc>(
        builder: (context, cartBloc, child) {
          if (cartBloc.state is CartLoaded) {
            final cartState = cartBloc.state as CartLoaded;
            return Stack(
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      cartBloc.add(ClearCartEvent());
                      _saveOrderToFirebase(cartState.cartItems);
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                    emissionFrequency: 0.05,
                    numberOfParticles: 20,
                    gravity: 0.05,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      right: 20.0, left: 20, top: 37, bottom: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Success message
                      Text(
                        "Payment Successful!",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Success Icon
                      const Icon(
                        Icons.check_circle_outline,
                        size: 150,
                        color: Colors.green,
                      ),
                      const SizedBox(height: 20),

                      // Receipt
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Receipt",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Display cart items
                            for (var item in cartState.cartItems)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${item.name} x ${item.quantity}",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary),
                                    ),
                                    Text(
                                      "RWF ${item.getTotalPrice().toStringAsFixed(2)}",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary),
                                    ),
                                  ],
                                ),
                              ),
                            // const SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 10.0, top: 0),
                              child: Divider(
                                color: Theme.of(context).colorScheme.tertiary,
                                thickness: 1,
                              ),
                            ),
                            // Total price
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total:",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                Text(
                                  'RWF ${cartState.totalPrice.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      // Clear cart button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(300, 50),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onPressed: () {
                          cartBloc.add(ClearCartEvent());
                          _saveOrderToFirebase(cartState.cartItems);
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                        child:
                            const Text('Home', style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
