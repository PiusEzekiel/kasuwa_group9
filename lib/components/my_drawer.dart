import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasuwa/components/my_drawer_tile.dart';
import 'package:kasuwa/screens/home/views/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import for Firebase Auth

import '../screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import '../screens/home/views/forum_screen.dart';
import '../screens/cart/views/payment_screen.dart';
import '../screens/cart/views/cart_screen.dart';

class MyDrawer extends StatefulWidget {
  final UserRepository userRepository;

  const MyDrawer({super.key, required this.userRepository});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInBloc, SignInState>(
      builder: (context, state) {
        return Drawer(
          backgroundColor: Theme.of(context).colorScheme.onTertiary,
          child: Column(
            children: [
              //app logo
              Padding(
                padding:
                    const EdgeInsets.only(top: 80.0, right: 50.0, left: 110.0),
                child: Row(
                  children: [
                    Image.asset(
                      'images/kasuwa_logo.png',
                      scale: 6,
                    ),
                  ],
                ),
              ),
              FutureBuilder<String>(
                future: widget.userRepository.getUserName(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 30.0, left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Hi, ${snapshot.data}!',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Text('Error fetching username');
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 20.0, top: 2, right: 20, left: 20),
                child: Divider(
                  color: Theme.of(context).colorScheme.tertiary,
                  thickness: 3,
                ),
              ),

              //home
              MyDrawerTile(
                text: 'H O M E',
                icon: Icons.home_outlined,
                onTap: () {
                  Navigator.pop(context);
                },
              ),

              //profile
              MyDrawerTile(
                text: 'P R O F I L E',
                icon: Icons.person_outline,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const ProfileScreen();
                  }));
                },
              ),
              //forum
              MyDrawerTile(
                text: 'F O R U M',
                icon: Icons.forum_outlined,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const ForumScreen();
                  }));
                },
              ),
              // shopping cart
              MyDrawerTile(
                text: 'C A R T',
                icon: Icons.shopping_cart_outlined,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push<void>(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const CartScreen(),
                      ));
                },
              ),

              //payment
              MyDrawerTile(
                text: 'P A Y M E N T',
                icon: Icons.credit_card_outlined,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return PaymentMethodsScreen();
                  }));
                },
              ),

              //logout
              const Spacer(),
              MyDrawerTile(
                text: 'L O G O U T',
                icon: Icons.logout_outlined,
                onTap: () {
                  context.read<SignInBloc>().add(SignOutRequired());
                },
              ),
              const SizedBox(height: 40.0)
            ],
          ),
        );
      },
    );
  }
}

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> getUserName() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userId = user.uid;
      final DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(userId).get();
      if (snapshot.exists) {
        return snapshot.get('name') as String;
      } else {
        return 'Guest1';
      }
    } else {
      return 'Guest2';
    }
  }
}
