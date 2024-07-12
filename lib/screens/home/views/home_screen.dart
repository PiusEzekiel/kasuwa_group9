import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasuwa/blocs/cart_bloc/bloc/cart_bloc.dart';
import 'package:kasuwa/components/my_drawer.dart';
import 'package:kasuwa/screens/cart/models/cart_item.dart';
import 'package:kasuwa/screens/home/blocs/get_kasuwa_bloc/get_kasuwa_bloc.dart';
import 'package:kasuwa/screens/cart/views/cart_screen.dart';
import 'package:provider/provider.dart';
// import '../../cart/models/cart_item.dart';
import 'details_screen.dart';
import 'package:kasuwa_repository/kasuwa_repository.dart';

class HomeScreen extends StatefulWidget {
  // final Kasuwa kasuwa;
  final List<Kasuwa> kasuwas; // Now it accepts a list
  const HomeScreen({required this.kasuwas, Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserRepository _userRepository = UserRepository();
  // final List<CartItem> cartItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Flexible(
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
                    builder: (BuildContext context) => const CartScreen(),
                  ));
            },
            icon: Icon(Icons.shopping_cart,
                size: 30, color: Theme.of(context).colorScheme.primary),
          ),
        ],
      ),
      drawer: MyDrawer(userRepository: _userRepository),
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
                    final kasuwa = state.kasuwas[i]; // Get the current Kasuwa

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
                                  kasuwa,
                                ),
                              ));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ), // Only top corners rounde
                              child: Image.network(
                                kasuwa.picture,
                                // scale: 10,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),

                              //name of the product
                              child: Text(kasuwa.name,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),

                              //description of the product
                              child: Text(kasuwa.description,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
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
                                              "RWF ${kasuwa.price - (kasuwa.price * (kasuwa.discount / 100))}0",
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                              )),
                                          // const SizedBox(
                                          //   height: 2,
                                          // ),
                                          Text(
                                            "RWF ${kasuwa.price}.00",
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
                                    onPressed: () {
                                      // Get the CartBloc instance from the context
                                      final cartBloc = context.read<CartBloc>();

                                      // Create a CartItem instance
                                      final cartItem = CartItem(
                                        kasuwaId: kasuwa.kasuwaId,
                                        name: kasuwa.name,
                                        discount: kasuwa.price -
                                            (kasuwa.price *
                                                (kasuwa.discount / 100)),
                                        // price: kasuwa.price,
                                        quantity: 1,
                                        imageUrl: kasuwa.picture,
                                      );

                                      // Add the item to the cart using the CartBloc
                                      cartBloc.add(
                                          AddToCartEvent(cartItem: cartItem));

                                      // Show the snackbar
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Center(
                                            child: Text(
                                              '${kasuwa.name} added to cart!',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                              ),
                                            ),
                                          ),
                                          duration: const Duration(seconds: 2),
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      );
                                    },
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
