part of 'cart_bloc.dart';

// Define the CartState
abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> cartItems;

  const CartLoaded({required this.cartItems});

  double get totalPrice {
    double total = 0.0;
    for (var item in cartItems) {
      total += item.getTotalPrice();
    }
    return total;
  }

  @override
  List<Object> get props => [cartItems];
}

class CartError extends CartState {
  final String message;

  const CartError({required this.message});

  @override
  List<Object> get props => [message];
}
