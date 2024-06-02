import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width - (40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 10),
                  ),
                ],
                image: const DecorationImage(
                  image: AssetImage('images/bananas.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          flex: 2,
                          child: Text(
                            'Sweet Bananas',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'RWF 500.00',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                const Text(
                                  'RWF 1000.00',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // //trying to display freshness and pieces
                    // Container(
                    //   decoration: BoxDecoration(
                    //     color: Colors.red,
                    //     borderRadius: BorderRadius.circular(10),
                    //   ),
                    //   child: const Padding(
                    //     padding:
                    //         EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    //     child: Text(
                    //       'pieces',
                    //       style: TextStyle(
                    //         color: Colors.white,
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: 8,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(
                    //   width: 8,
                    // ),
                    // Container(
                    //   decoration: BoxDecoration(
                    //     color: Colors.green.withOpacity(0.6),
                    //     borderRadius: BorderRadius.circular(10),
                    //   ),
                    //   child: const Padding(
                    //     padding:
                    //         EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    //     child: Text(
                    //       'Fresh',
                    //       style: TextStyle(
                    //         color: Colors.white,
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: 8,
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Colors.black.withOpacity(0.2),
                              //     blurRadius: 10,
                              //     offset: const Offset(2, 2),
                              //   ),
                              // ],
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  // Icon(Icons.shopping_cart,
                                  //     size: 30, color: Colors.red),
                                  Text(
                                    'Original bananas, naturally grown without any chemicals in the fertile soils of Rwanda. They are sweet and delicious.',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          elevation: 3.0,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Add to Cart',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
