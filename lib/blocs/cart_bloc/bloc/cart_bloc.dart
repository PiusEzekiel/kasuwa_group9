import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kasuwa/screens/cart/models/cart_item.dart';
import 'package:equatable/equatable.dart';
// import 'package:kasuwa_repository/kasuwa_repository.dart';
// import 'package:your_app/cart/models/cart_item.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CartBloc() : super(CartInitial()) {
    // Register event handler for LoadCartEvent
    on<LoadCartEvent>((event, emit) async {
      await _loadCart(emit);
    });

    on<AddToCartEvent>((event, emit) async {
      try {
        final user = _auth.currentUser;
        if (user != null) {
          final docRef = _firestore
              .collection('users')
              .doc(user.uid)
              .collection('cart')
              .doc(event.cartItem.name);
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
          // Emit CartLoaded after adding to cart
          emit(CartLoaded(cartItems: await _loadCartItems()));
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
              .doc(event.cartItem.name)
              .delete();
          // Emit CartLoaded after removing from cart
          emit(CartLoaded(cartItems: await _loadCartItems()));
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
              .doc(event.cartItem.name)
              .update({'quantity': event.quantity});
          // Emit CartLoaded after updating quantity
          emit(CartLoaded(cartItems: await _loadCartItems()));
        } else {
          emit(CartError(message: 'User not logged in'));
        }
      } catch (e) {
        emit(CartError(message: 'Error updating cart quantity: $e'));
      }
    });

    on<ClearCartEvent>((event, emit) async {
      try {
        final user = _auth.currentUser;
        if (user != null) {
          await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('cart')
              .get()
              .then((snapshot) {
            for (var doc in snapshot.docs) {
              doc.reference.delete();
            }
          });
          // Emit CartLoaded after clearing the cart
          emit(CartLoaded(cartItems: await _loadCartItems()));
        } else {
          emit(CartError(message: 'User not logged in'));
        }
      } catch (e) {
        emit(CartError(message: 'Error clearing cart: $e'));
      }
    });

    // Load cart items on initialization
    add(LoadCartEvent());
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
