part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class LoadCartEvent extends CartEvent {}

class AddToCartEvent extends CartEvent {
  final CartItem cartItem;

  const AddToCartEvent({required this.cartItem});

  @override
  List<Object> get props => [cartItem];
}

class RemoveFromCartEvent extends CartEvent {
  final CartItem cartItem;

  const RemoveFromCartEvent({required this.cartItem});

  @override
  List<Object> get props => [cartItem];
}

class UpdateCartQuantityEvent extends CartEvent {
  final CartItem cartItem;
  final int quantity;

  const UpdateCartQuantityEvent(
      {required this.cartItem, required this.quantity});

  @override
  List<Object> get props => [cartItem, quantity];
}

class ClearCartEvent extends CartEvent {}
