import 'package:flutter/material.dart';
import 'package:kasuwa/blocs/cart_bloc/bloc/cart_bloc.dart';
import 'package:kasuwa/screens/cart/views/cart_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/kasuwa_logo.png', // Make sure the path is correct
              scale: 10,
            ),
            const SizedBox(
              width: 1,
            ),
          ],
        ),
      ),
      actions: [
        BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoaded) {
              return InkWell(
                // splashColor: Colors.transparent,
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const CartScreen(),
                    ),
                  );
                },
                child: Stack(
                  // alignment: Alignment.center,
                  children: [
                    if (state.cartItems.isNotEmpty)
                      Positioned(
                        // height: 30,
                        right: 14,
                        top: 1,
                        child: Container(
                          height: 22,
                          width: 22,
                          // padding: const EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 15,
                            minHeight: 15,
                          ),
                          child: Text(
                            '${state.cartItems.length}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: SizedBox(
                        // height: 60,
                        child: IconButton(
                          onPressed: () {
                            Navigator.push<void>(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const CartScreen(),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.shopping_cart,
                            size: 35,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
