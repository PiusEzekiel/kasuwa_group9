part of 'cart_bloc.dart';

abstract class CartEvent {}

class AddToCartEvent extends CartEvent {
  final CartItem cartItem;

  AddToCartEvent({required this.cartItem});
}

class RemoveFromCartEvent extends CartEvent {
  final CartItem cartItem;

  RemoveFromCartEvent({required this.cartItem});
}

class UpdateCartQuantityEvent extends CartEvent {
  final CartItem cartItem;
  final int quantity;

  UpdateCartQuantityEvent({required this.cartItem, required this.quantity});
}

class LoadCartEvent extends CartEvent {}
