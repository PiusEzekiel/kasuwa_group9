// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:flutter/material.dart';
// import 'package:learn_basics/pages/card.dart';

void main() {
  runApp(PaymentMethodsScreen());
}

class PaymentMethodsScreen extends StatefulWidget {
  @override
  _PaymentMethodsScreenState createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  int _selectedPaymentMethod = -1;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/payment': (context) => PaymentMethodsScreen(),
        // '/card': (context) => CreditCardPaymentScreen(),
      },
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                // Open menu
              },
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.only(left: 50.0, right: 50.0, bottom: 76.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Payment Methods',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Select your preferred payment method:',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 16.0),
              Expanded(
                child: ListView(
                  children: [
                    _buildPaymentMethodItem(
                      'Credit Card',
                      'images/card.png',
                      0,
                    ),
                    _buildPaymentMethodItem(
                      'Momo Pay',
                      'images/momo.png',
                      1,
                    ),
                    _buildPaymentMethodItem(
                      'PayPal',
                      'images/paypal.png',
                      2,
                    ),
                    _buildPaymentMethodItem(
                      'Internet Bank',
                      'images/bank.png',
                      3,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48.0),
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: _selectedPaymentMethod == -1
                    ? null
                    : () {
                        Navigator.pushNamed(context, '/card');
                      },
                child: Text('Next'),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          onTap: (index) {},
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.grey),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart, color: Colors.grey),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, color: Colors.grey),
              label: '',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodItem(String title, String imagePath, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = index;
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Radio(
              value: index,
              groupValue: _selectedPaymentMethod,
              onChanged: (int? value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                });
              },
            ),
            SizedBox(width: 16.0),
            Image.asset(
              imagePath,
              width: 48.0,
              height: 48.0,
            ),
            SizedBox(width: 20.0),
            Expanded(
              child: Text(title),
            ),
          ],
        ),
      ),
    );
  }
}
