import 'package:kasuwa_repository/kasuwa_repository.dart';

class CartItem {
  Kasuwa kasuwa;
  int quantity;

  CartItem({
    required this.kasuwa,
    required this.quantity,
  });

  double get totalPrice => kasuwa.price * quantity;
}
