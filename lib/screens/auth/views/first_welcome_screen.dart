// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:kasuwa/screens/auth/views/welcome_screen.dart';

class FirstWelcomeScreen extends StatelessWidget {
  const FirstWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Align(
                alignment: const AlignmentDirectional(20, -1),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Theme.of(context).colorScheme.tertiary),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 40.0, horizontal: 20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'images/kasuwa_logo.png',
                              scale: 10,
                            ),
                            const SizedBox(
                              width: 1,
                            ),
                            const Text(
                              'asuwa',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 25,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(-0, 1.2),
                child: Container(
                  // height: MediaQuery.of(context).size.height,
                  height: 600,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Theme.of(context).colorScheme.tertiary,
                    image: const DecorationImage(
                      image: AssetImage('images/welcome_background.png'),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 100.0, horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 100,
                        ),
                        Text(
                            'Shop the freshest, locally-grown produce with ease and convenience!',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 19,
                              color: Colors.grey.shade700,
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                            'When you shop on Kasuwa, you are supporting hardworking local farmers and businesses and a more transparent and sustainable food system.',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 19,
                              color: Colors.grey.shade700,
                            )),
                        const SizedBox(
                          height: 45,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: TextButton(
                            onPressed: () {
                              // Navigator.pop(context);
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             const WelcomeScreen()));
                              Navigator.of(context).pop();
                            },
                            style: TextButton.styleFrom(
                              elevation: 3.0,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Get Started',
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
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(0.8, -0.8),
                child: Container(
                  height: MediaQuery.of(context).size.width / 1.5,
                  width: MediaQuery.of(context).size.width / 1.5,
                  decoration: BoxDecoration(
                      image: const DecorationImage(
                          image: AssetImage('images/shoppers.png'),
                          fit: BoxFit.scaleDown,
                          scale: 0.5),
                      shape: BoxShape.circle,
                      // color: Theme.of(context).colorScheme.onPrimary
                      color: Colors.grey.shade300),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
