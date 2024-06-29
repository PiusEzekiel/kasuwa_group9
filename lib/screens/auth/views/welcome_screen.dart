import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/authentication_bloc/authentication_bloc.dart';
import '../blocs/sign_in_bloc/sign_in_bloc.dart';
import '../blocs/sign_up_bloc/sign_up_bloc.dart';
import 'sign_in_screen.dart';
import 'sign_up_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 0, length: 2, vsync: this);

    // Schedule the dialog to be shown after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _openanimatedDiag();
    });
  }

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
                alignment: const AlignmentDirectional(20, -1.2),
                child: Container(
                  height: MediaQuery.of(context).size.width,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(2.7, -1.2),
                child: Container(
                  height: MediaQuery.of(context).size.width / 1.4,
                  width: MediaQuery.of(context).size.width / 1.5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
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
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 1.8,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50.0),
                        child: TabBar(
                          controller: tabController,
                          unselectedLabelColor: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.5),
                          labelColor: Theme.of(context).colorScheme.onSurface,
                          tabs: const [
                            Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          child: TabBarView(
                        controller: tabController,
                        children: [
                          BlocProvider<SignInBloc>(
                            create: (context) => SignInBloc(context
                                .read<AuthenticationBloc>()
                                .userRepository),
                            child: const SignInScreen(),
                          ),
                          BlocProvider<SignUpBloc>(
                            create: (context) => SignUpBloc(context
                                .read<AuthenticationBloc>()
                                .userRepository),
                            child: const SignUpScreen(),
                          ),
                        ],
                      ))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //Adding Welcome Dialog
  Future<void> _openanimatedDiag() async {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: const Duration(milliseconds: 0),
        pageBuilder: (BuildContext buildContext, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          // Pass the context from WelcomeScreen to the dialog
          return WelcomeDialog(context: buildContext);
        },
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        });
  }
}

// Create a new widget for the dialog content
class WelcomeDialog extends StatelessWidget {
  final BuildContext context;

  const WelcomeDialog({required this.context});

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
