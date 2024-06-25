import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasuwa/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:kasuwa/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:kasuwa/screens/auth/views/first_welcome_screen.dart';
import 'package:kasuwa/screens/home/blocs/get_kasuwa_bloc/get_kasuwa_bloc.dart';
import 'package:kasuwa_repository/kasuwa_repository.dart';

import 'screens/auth/views/welcome_screen.dart';
import 'screens/home/views/home_screen.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Kasuwa',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.light(
            surface: Colors.grey.shade100,
            onSurface: Colors.black,
            primary: Colors.orange.shade800,
            onPrimary: Colors.white,
            tertiary: Colors.blue.shade200,
            onTertiary: Colors.white,
          ),
        ),
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: ((context, state) {
            if (state.status == AuthenticationStatus.authenticated) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => SignInBloc(
                        context.read<AuthenticationBloc>().userRepository),
                  ),
                  BlocProvider(
                    create: (context) => GetKasuwaBloc(
                      FirebaseKasuwaRepo(),
                    )..add(GetKasuwa()),
                  ),
                ],
                child: const HomeScreen(),
              );
            } else {
              // return const WelcomeScreen();
              return const FirstWelcomeScreen();
            }
          }),
        ));
  }
}
