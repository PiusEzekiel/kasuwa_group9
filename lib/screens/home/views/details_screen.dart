import 'package:flutter/material.dart';
import 'package:kasuwa_repository/kasuwa_repository.dart';

import '../../../models/cart_item.dart';
import 'package:collection/collection.dart'; // Import the collection package

class DetailScreen extends StatefulWidget {
  final Kasuwa kasuwa;
  const DetailScreen(this.kasuwa, {super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final List<CartItem> cartItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          children: [
            // Product Image
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width - (40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 10),
                  ),
                ],
                image: DecorationImage(
                  image: NetworkImage(
                    widget.kasuwa.picture,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Product Details
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name and Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            widget.kasuwa.name,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "RWF ${widget.kasuwa.price - (widget.kasuwa.price * (widget.kasuwa.discount / 100))}0",
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  "RWF ${widget.kasuwa.price}.00",
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Product Description
                    Text(
                      widget.kasuwa.detailsDescription,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Add to Cart Button
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: TextButton(
                        onPressed: () {
                          _addToCart(
                              widget.kasuwa); // Call the _addToCart function
                        },
                        style: TextButton.styleFrom(
                          elevation: 3.0,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Add to Cart',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Add to Cart Logic
  void _addToCart(Kasuwa kasuwa) {
    setState(() {
      // Find existing item in the cart
      CartItem? existingItem = cartItems.firstWhereOrNull(
        (item) => item.kasuwa == kasuwa,
      );

      if (existingItem != null) {
        // Increase quantity of existing item
        existingItem.quantity++;
      } else {
        // Add new item to the cart
        cartItems.add(CartItem(kasuwa: kasuwa, quantity: 1));
      }
    });
  }

  // Remove from Cart Logic
  void _removeFromCart(Kasuwa kasuwa) {
    setState(() {
      cartItems.removeWhere((item) => item.kasuwa == kasuwa);
    });
  }

  // Get Total Price
  double get totalPrice {
    double total = 0;
    for (CartItem cartItem in cartItems) {
      total += cartItem.totalPrice;
    }
    return total;
  }

  // Get Total Quantity
  int get totalQuantity {
    int total = 0;
    for (CartItem cartItem in cartItems) {
      total += cartItem.quantity;
    }
    return total;
  }

  // Clear Cart Logic
  void _clearCart() {
    setState(() {
      cartItems.clear();
    });
  }
}
