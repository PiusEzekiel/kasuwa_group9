// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasuwa/components/my_drawer.dart';
import 'package:kasuwa/screens/home/blocs/get_kasuwa_bloc/get_kasuwa_bloc.dart';
import 'package:kasuwa/screens/auth/views/cart_screen.dart';

// import '../../../models/cart_item.dart';
import 'details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<CartItem> cartItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Flexible(
          // padding: const EdgeInsets.only(left: 55.0, right: 50.0),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/kasuwa_logo.png',
                  scale: 10,
                ),
                const SizedBox(
                  width: 1,
                ),
                // const Text(
                //   'asuwa',
                //   style: TextStyle(
                //     fontWeight: FontWeight.w900,
                //     fontSize: 25,
                //   ),
                // ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push<void>(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => ShoppingCartScreen(
                      cartItems: cartItems,
                    ),
                  ));
            },
            icon: const Icon(Icons.shopping_cart, size: 30, color: Colors.red),
          ),
          // IconButton(
          //   onPressed: () {
          //     context.read<SignInBloc>().add(SignOutRequired());
          //   },
          //   icon: const Icon(Icons.logout_outlined),
          // ),
        ],
      ),
      drawer: const MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<GetKasuwaBloc, GetKasuwaState>(
          builder: (context, state) {
            //state handling for homepage
            if (state is GetKasuwaSuccess) {
              return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      //will change the aspect ratio to 9/18
                      childAspectRatio: 9 / 17),

                  //returning 4 items for now
                  // state.kasuwas.length, to return all items on the list on firebase
                  itemCount: state.kasuwas.length,
                  itemBuilder: (context, int i) {
                    return Material(
                      elevation: 3,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) => DetailScreen(
                                  state.kasuwas[i],
                                ),
                              ));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              state.kasuwas[i].picture,
                              // scale: 10,
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(
                            //     horizontal: 12,
                            //     vertical: 4,
                            //   ),
                            //   child: Row(
                            //     children: [
                            //       Container(
                            //         decoration: BoxDecoration(
                            //           color: Colors.red,
                            //           borderRadius: BorderRadius.circular(10),
                            //         ),
                            //         child: const Padding(
                            //           padding: EdgeInsets.symmetric(
                            //               horizontal: 6, vertical: 3),
                            //           child: Text(
                            //             '10',
                            //             style: TextStyle(
                            //               color: Colors.white,
                            //               fontWeight: FontWeight.bold,
                            //               fontSize: 8,
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //       const SizedBox(
                            //         width: 8,
                            //       ),
                            //       Container(
                            //         decoration: BoxDecoration(
                            //           color: Colors.green.withOpacity(0.6),
                            //           borderRadius: BorderRadius.circular(10),
                            //         ),
                            //         child: const Padding(
                            //           padding: EdgeInsets.symmetric(
                            //               horizontal: 6, vertical: 3),
                            //           child: Text(
                            //             '10',
                            //             style: TextStyle(
                            //               color: Colors.white,
                            //               fontWeight: FontWeight.bold,
                            //               fontSize: 8,
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // const SizedBox(
                            //   height: 6,
                            // ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),

                              //name of the product
                              child: Text(state.kasuwas[i].name,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),

                              //description of the product
                              child: Text(state.kasuwas[i].description,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 1,
                              ),
                              //changing row to column
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          //price of the product
                                          Text(
                                              "RWF ${state.kasuwas[i].price - (state.kasuwas[i].price * (state.kasuwas[i].discount / 100))}0",
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14,
                                              )),
                                          // const SizedBox(
                                          //   height: 2,
                                          // ),
                                          Text(
                                            "RWF ${state.kasuwas[i].price}.00",
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 11,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.add_circle_outline_sharp,
                                      size: 35,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            } else if (state is GetKasuwaLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is GetKasuwaFailure) {
              return const Center(
                child: Text('Failed to load data'),
              );
            } else {
              return const Center(
                child: Text('Initial State'),
              );
            }
          },
        ),
      ),
    );
  }
}
