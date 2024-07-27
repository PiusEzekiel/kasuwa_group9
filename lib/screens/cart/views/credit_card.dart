import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:kasuwa/screens/cart/views/payment_success.dart';

class CreditCard extends StatefulWidget {
  const CreditCard({super.key});

  @override
  State<CreditCard> createState() => _CreditCardState();
}

class _CreditCardState extends State<CreditCard> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Default card values
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = ''; // Use this for the CreditCardWidget
  String cvvCode = '';
  bool isCvvFocused = false;
  bool showForm = false; // Flag to control form visibility

  // Selected card data
  Map<String, dynamic>? selectedCardData;

  //function to handle payment
  void userTappedPay() {
    if (selectedCardData != null) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(
                  'Confirm Payment',
                  style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.primary),
                ),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: [
                      Text(
                        'Card Number: ${selectedCardData!['cardNumber']}',
                        style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.tertiary),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Expiry Date: ${selectedCardData!['expiryDate']}',
                        style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.tertiary),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Card Holder Name: ${selectedCardData!['cardHolderName']}',
                        style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.tertiary),
                      ),
                      // Don't show CVV in the confirmation dialog
                    ],
                  ),
                ),
                actions: [
                  //cancel button
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.red)),
                  ),
                  // ok button
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const PaymentSuccessScreen()));
                    },
                    child: Text(
                      'YES',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                ],
              ));
    } else {
      // Show a message if no card is selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a credit card')),
      );
    }
  }

  // Function to save card details to Firestore
  Future<void> _saveCardDetails() async {
    if (formKey.currentState!.validate()) {
      // Validate the form before saving
      final user = _auth.currentUser;
      if (user != null) {
        final cardData = {
          'cardNumber': cardNumber,
          'expiryDate': expiryDate,
          'cardHolderName': cardHolderName,
          'cvvCode': cvvCode,
        };
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('cards')
            .add(cardData);
        // After saving, hide the form and update the state
        setState(() {
          showForm = false;
        });
      }
    }
  }

  // Function to delete a card from Firestore
  Future<void> _deleteCard(String cardId) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('cards')
          .doc(cardId)
          .delete();
    }
  }

  // Input validation functions
  String? _validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a card number';
    }
    if (value.length < 13 || value.length > 19) {
      return 'Card number must be between 13 and 19 digits';
    }
    return null;
  }

  String? _validateExpiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an expiry date';
    }
    if (value.length != 5 || !value.contains('/')) {
      return 'Expiry date must be in MM/YY format';
    }
    return null;
  }

  String? _validateCardHolderName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? _validateCvvCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a CVV code';
    }
    if (value.length != 3 && value.length != 4) {
      return 'CVV code must be 3 or 4 digits';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Pay with Card          ',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary, fontSize: 24.0),
            ),
          ],
        ),
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(bottom: 40.0, right: 20, left: 20, top: 10),
        child: SingleChildScrollView(
          child: SizedBox(
            height: 705,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Display selected card in a CreditCardWidget
                CreditCardWidget(
                  cardNumber: selectedCardData != null
                      ? selectedCardData!['cardNumber']
                      : cardNumber,
                  expiryDate: selectedCardData != null
                      ? selectedCardData!['expiryDate']
                      : expiryDate,
                  cardHolderName: selectedCardData != null
                      ? selectedCardData!['cardHolderName']
                      : cardHolderName, // Update cardHolderName here
                  cvvCode: selectedCardData != null
                      ? selectedCardData!['cvvCode']
                      : cvvCode,
                  showBackView: isCvvFocused,
                  onCreditCardWidgetChange: (p0) {},
                  // Add this line to show the cardholder name
                  cardType:
                      CardType.mastercard, // You can set the card type here
                  // You can customize the appearance of the card here
                  cardBgColor: Theme.of(context).colorScheme.tertiary,
                  labelCardHolder: 'CARD HOLDER',
                  isHolderNameVisible: true,
                  enableFloatingCard: true,
                  backgroundImage: 'images/kasuwa_logo.png',

                  // chipColor: Theme.of(context).colorScheme.primary,
                  // height: 175,
                ),
                // Add new card button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Visibility(
                    visible:
                        !showForm, // Hide the button when the form is visible
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          showForm = true;
                        });
                      },
                      // child: const Text('Add New Card'),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.add_circle_outline_sharp,
                            size: 40,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Show the form only when showForm is true
                if (showForm)
                  Column(
                    children: [
                      SizedBox(
                        height: 250,
                        child: CreditCardForm(
                          cardNumber: cardNumber,
                          expiryDate: expiryDate,
                          cardHolderName:
                              cardHolderName, // Update cardHolderName here
                          cvvCode: cvvCode,
                          cvvValidationMessage: 'Please input a valid CVV',
                          dateValidationMessage: 'Please input a valid date',
                          numberValidationMessage:
                              'Please input a valid number',
                          cardNumberValidator: _validateCardNumber,
                          expiryDateValidator: _validateExpiryDate,
                          cvvValidator: _validateCvvCode,
                          obscureCvv: true,
                          cardHolderValidator: _validateCardHolderName,
                          onCreditCardModelChange: (data) {
                            setState(() {
                              cardNumber = data.cardNumber;
                              expiryDate = data.expiryDate;
                              cardHolderName =
                                  data.cardHolderName; // Update the state
                              cvvCode = data.cvvCode;
                              // isCvvFocused = data.isCvvFocused;
                            });
                          },
                          formKey: formKey,
                        ),
                      ),
                      // Button to show/hide the form
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  showForm = !showForm;
                                });
                              },
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  // color: Theme.of(context).colorScheme.tertiary,
                                  color: Colors.red,
                                  fontSize: 16.0,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            const Spacer(),
                            // Save button
                            TextButton(
                              onPressed: _saveCardDetails,
                              // onHover: (isHovering) { },
                              child: Text(
                                'Save Card',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: 16.0,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                if (!showForm)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, bottom: 3),
                        child: Text('choose a card to pay with!',
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Theme.of(context).colorScheme.tertiary),
                            textAlign: TextAlign.start),
                      ),
                    ],
                  ),
                // Show the listview only when showForm is false
                if (!showForm)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SizedBox(
                      height: 310,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _firestore
                            .collection('users')
                            .doc(_auth.currentUser!.uid)
                            .collection('cards')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final cards = snapshot.data!.docs;

                            return ListView.builder(
                              itemCount: cards.length,
                              itemBuilder: (context, index) {
                                final cardData =
                                    cards[index].data() as Map<String, dynamic>;
                                final cardId = cards[index].id;
                                return Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: ListTile(
                                      minVerticalPadding: 10,
                                      onTap: () {
                                        setState(() {
                                          selectedCardData = cardData;
                                          // Update the state variables used by CreditCardWidget
                                          cardNumber = cardData['cardNumber'];
                                          expiryDate = cardData['expiryDate'];
                                          cardHolderName =
                                              cardData['cardHolderName'];
                                          cvvCode = cardData['cvvCode'];
                                        });
                                      },
                                      title: Text(cardData['cardHolderName']),
                                      subtitle: Text(
                                          '**** **** **** ${cardData['cardNumber'].substring(12)}'),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              _deleteCard(cardId);
                                            },
                                            icon: const Icon(Icons.delete,
                                                color: Colors.red),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ),
                  ),

                const Spacer(),

                //pay button
                ElevatedButton(
                  onPressed: selectedCardData != null ? userTappedPay : null,
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(300, 50),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Pay Now',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
