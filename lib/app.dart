import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasuwa/blocs/cart_bloc/bloc/cart_bloc.dart';
import 'package:provider/provider.dart';
import 'package:kasuwa/app_view.dart';
import 'package:kasuwa/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:user_repository/user_repository.dart';

class MyApp extends StatelessWidget {
  final UserRepository userRepository;
  const MyApp(this.userRepository, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Use BlocProvider for CartBloc
        BlocProvider<CartBloc>(
          create: (context) => CartBloc(),
        ),
        RepositoryProvider.value(
          value: AuthenticationBloc(userRepository: userRepository),
        ),
      ],
      child: const MyAppView(),
    );
  }
}
