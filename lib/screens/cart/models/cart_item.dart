// import 'package:flutter/material.dart';
// import 'package:kasuwa_repository/kasuwa_repository.dart';

class CartItem {
  final dynamic kasuwaId;
  final String name;
  final double discount;
  int quantity;
  final String imageUrl;

  CartItem({
    required this.kasuwaId,
    required this.name,
    required this.discount,
    this.quantity = 1,
    required this.imageUrl,
  });

  // Function to increase quantity
  void increaseQuantity() {
    quantity++;
  }

  // Function to decrease quantity (with a minimum of 1)
  void decreaseQuantity() {
    if (quantity > 1) {
      quantity--;
    }
  }

  // Function to calculate total price
  double getTotalPrice() {
    return discount * quantity;
  }

//   // Remove from Cart Logic
// void _removeFromCart(Kasuwa kasuwa) {
//   setState(() {
//     cartItems.removeWhere((item) => item.kasuwa == kasuwa);
//   });
// }

// // Get Total Price
// double get totalPrice {
//   double total = 0;
//   for (CartItem cartItem in cartItems) {
//     total += cartItem.totalPrice;
//   }
//   return total;
// }

// // Get Total Quantity
// int get totalQuantity {
//   int total = 0;
//   for (CartItem cartItem in cartItems) {
//     total += cartItem.quantity;
//   }
//   return total;
// }

// // Clear Cart Logic
// void _clearCart() {
//   setState(() {
//     cartItems.clear();
//   });
// }
}
