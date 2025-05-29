import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nyxara/core/router/router_config.dart';
import 'package:nyxara/data/datasources/user_datasource.dart';
import 'package:nyxara/presentation/auth/bloc/auth_bloc.dart';

void main() {
  runApp(NyxaraApp());
}

class NyxaraApp extends StatelessWidget {
  final GoRouter _router = NyxaraRouter.returnRouter();

  NyxaraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(nyxaraDB: NyxaraDB()),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
        title: 'Nyxara App',
      ),
    );
  }
}
