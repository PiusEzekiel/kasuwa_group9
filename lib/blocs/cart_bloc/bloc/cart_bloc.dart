import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kasuwa/screens/cart/models/cart_item.dart';
// import 'package:kasuwa_repository/kasuwa_repository.dart';
// import 'package:your_app/cart/models/cart_item.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CartBloc() : super(CartInitial()) {
    on<AddToCartEvent>((event, emit) async {
      try {
        final user = _auth.currentUser;
        if (user != null) {
          final docRef = _firestore
              .collection('users')
              .doc(user.uid)
              .collection('cart')
              .doc(event.cartItem.name); // Use name
          final existingData = await docRef.get();
          if (existingData.exists) {
            // Update quantity if item exists
            await docRef
                .update({'quantity': existingData.data()!['quantity'] + 1});
          } else {
            // Add new item to cart
            await docRef.set({
              'name': event.cartItem.name,
              'discount': event.cartItem.discount,
              'quantity': 1,
              'imageUrl': event.cartItem.imageUrl,
            });
          }
          emit(CartLoaded(
              cartItems: await _loadCartItems())); // Emit after each operation
        } else {
          emit(CartError(message: 'User not logged in'));
        }
      } catch (e) {
        emit(CartError(message: 'Error adding to cart: $e'));
      }
    });

    on<RemoveFromCartEvent>((event, emit) async {
      try {
        final user = _auth.currentUser;
        if (user != null) {
          await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('cart')
              .doc(event.cartItem.name) // Use name
              .delete(); // Await the deletion
          emit(CartLoaded(
              cartItems: await _loadCartItems())); // Emit after deletion
        } else {
          emit(CartError(message: 'User not logged in'));
        }
      } catch (e) {
        emit(CartError(message: 'Error removing from cart: $e'));
      }
    });

    on<UpdateCartQuantityEvent>((event, emit) async {
      try {
        final user = _auth.currentUser;
        if (user != null) {
          await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('cart')
              .doc(event.cartItem.name) // Use name
              .update({'quantity': event.quantity}); // Await the update
          emit(CartLoaded(
              cartItems: await _loadCartItems())); // Emit after update
        } else {
          emit(CartError(message: 'User not logged in'));
        }
      } catch (e) {
        emit(CartError(message: 'Error updating cart quantity: $e'));
      }
    });

    on<LoadCartEvent>((event, emit) async {
      // Make _loadCart async
      await _loadCart(emit); // Await the _loadCart function
    });
  }

  Future<void> _addToCart(CartItem cartItem, Emitter<CartState> emit) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final docRef = _firestore
            .collection('users')
            .doc(user.uid)
            .collection('cart')
            .doc(cartItem.name); // Use name
        final existingData = await docRef.get();
        if (existingData.exists) {
          // Update quantity if item exists
          await docRef
              .update({'quantity': existingData.data()!['quantity'] + 1});
        } else {
          // Add new item to cart
          await docRef.set({
            'name': cartItem.name,
            'discount': cartItem.discount,
            'quantity': 1,
            'imageUrl': cartItem.imageUrl,
          });
        }
        emit(CartLoaded(
            cartItems: await _loadCartItems())); // Emit after each operation
      } else {
        emit(CartError(message: 'User not logged in'));
      }
    } catch (e) {
      emit(CartError(message: 'Error adding to cart: $e'));
    }
  }

  Future<void> _removeFromCart(
      CartItem cartItem, Emitter<CartState> emit) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('cart')
            .doc(cartItem.name) // Use name
            .delete(); // Await the deletion
        emit(CartLoaded(
            cartItems: await _loadCartItems())); // Emit after deletion
      } else {
        emit(CartError(message: 'User not logged in'));
      }
    } catch (e) {
      emit(CartError(message: 'Error removing from cart: $e'));
    }
  }

  Future<void> _updateCartQuantity(
      CartItem cartItem, int quantity, Emitter<CartState> emit) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('cart')
            .doc(cartItem.name) // Use name
            .update({'quantity': quantity}); // Await the update
        emit(
            CartLoaded(cartItems: await _loadCartItems())); // Emit after update
      } else {
        emit(CartError(message: 'User not logged in'));
      }
    } catch (e) {
      emit(CartError(message: 'Error updating cart quantity: $e'));
    }
  }

  Future<List<CartItem>> _loadCartItems() async {
    final user = _auth.currentUser;
    if (user != null) {
      final cartSnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .get();
      return cartSnapshot.docs.map((doc) {
        return CartItem(
          kasuwaId: doc.id,
          name: doc.data()['name'],
          discount: doc.data()['discount'],
          quantity: doc.data()['quantity'],
          imageUrl: doc.data()['imageUrl'],
        );
      }).toList();
    } else {
      return [];
    }
  }

  Future<void> _loadCart(Emitter<CartState> emit) async {
    try {
      final cartItems = await _loadCartItems(); // Await here
      emit(CartLoaded(cartItems: cartItems)); // Emit after awaiting
    } catch (e) {
      emit(CartError(message: 'Error loading cart: $e'));
    }
  }
}
