// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:kasuwa/screens/cart/views/credit_card.dart';

// void main() {
//   runApp(PaymentMethodsScreen());
// }

class PaymentMethodsScreen extends StatefulWidget {
  @override
  _PaymentMethodsScreenState createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  int _selectedPaymentMethod = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon(
            //   Icons.forum_outlined,
            //   color: Theme.of(context).colorScheme.primary,
            //   size: 28.0,
            // ),
            // const SizedBox(width: 8.0),
            Text(
              'Payment Methods          ',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary, fontSize: 24.0),
            ),
          ],
        ),
      ),
      body: Padding(
        padding:
            EdgeInsets.only(left: 50.0, right: 50.0, bottom: 40.0, top: 70),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Text(
            //   'Payment Methods',
            //   style: TextStyle(
            //     color: Theme.of(context).colorScheme.primary,
            //     fontSize: 24.0,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // SizedBox(height: 40.0),
            Text(
              'Select your preferred payment method:',
              style: TextStyle(
                fontSize: 20.0,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 25.0),
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
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(300, 50),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: _selectedPaymentMethod == -1
                  ? null
                  : () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CreditCard();
                      }));
                    },
              child: Text(
                'Next',
                style: TextStyle(fontSize: 18),
              ),
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
        padding: EdgeInsets.symmetric(
          vertical: 15.0,
        ),
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
              activeColor: Theme.of(context).colorScheme.primary,
              // fillColor: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(width: 16.0),
            Image.asset(
              imagePath,
              width: 48.0,
              height: 48.0,
            ),
            SizedBox(width: 20.0),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                    fontSize: 18.0,
                    color: Theme.of(context).colorScheme.tertiary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
