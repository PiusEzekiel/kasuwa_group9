import 'package:flutter/material.dart';
import 'package:kasuwa/blocs/cart_bloc/bloc/cart_bloc.dart';
import 'package:kasuwa/screens/cart/models/cart_item.dart';
// import 'package:kasuwa/screens/cart/views/order_history';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0.0,
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.receipt_long,
                color: Theme.of(context).colorScheme.primary,
                size: 28.0,
              ),
              const SizedBox(width: 8.0),
              Text('Order History       ',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 24.0,
                  )),
            ],
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: _auth.currentUser != null
              ? _firestore
                  .collection('users')
                  .doc(_auth.currentUser!.uid)
                  .collection('orders')
                  .orderBy('timestamp', descending: true)
                  .snapshots()
              : null,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Error fetching orders'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.data == null) {
              return const Center(child: Text('Please log in to view orders'));
            }

            final orders = snapshot.data!.docs;

            if (orders.isEmpty) {
              return const Center(child: Text('No orders found'));
            }

            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index].data();
                final orderID = orders[index].id;
                final items = order['items'];
                final totalPrice = order['total_price'];
                final timestamp = order['timestamp'].toDate();

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12.0),
                  child: ExpansionTile(
                    title: Text(
                      'Order ID: $orderID',
                      style: TextStyle(
                        fontSize: 16,
                        // color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    subtitle: Text(
                      'Total: RWF $totalPrice',
                      style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.secondary),
                      // .substring(0, 22),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            for (var item in items)
                              Text(
                                '${item['name']} x ${item['quantity']} _____ RWF ${item['price']}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            const SizedBox(height: 15),
                            Text(
                              'Date: ${timestamp.toLocal()}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
