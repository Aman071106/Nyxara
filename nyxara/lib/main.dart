import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nyxara/core/router/router_config.dart';
import 'package:nyxara/data/datasources/user_datasource.dart';
import 'package:nyxara/data/repositories_impl/breach_repo_impl.dart';
import 'package:nyxara/presentation/auth/bloc/auth_bloc.dart';

void main() async {
  BreachRepoImpl breachRepoImpl = BreachRepoImpl();
  String email = "aman@gmail.com";
  try {
    print("------ISBREACHED----");
    print((await breachRepoImpl.checkBreach(email)).toString());
  } catch (e) {
    log(e.toString());
  }
  try {
    final analytics = await breachRepoImpl.fetchAnalytics(email);
    print("------WHAT BREACHED----");

    // Print the breachMetrics and breachesSummary fields explicitly
    print('Breach Metrics: ${analytics!.xposedData[0].children[0]}');
    print('Breaches Summary: ${analytics.yearwiseDetails}');

    // If you want to print specific subfields, you can access them like this:
    // Replace these with the actual fields of your breachMetrics and breachesSummary
    if (analytics!.riskLabel != null) {
      print('Breach Metrics Details: ${analytics.yearwiseDetails}');

      // Add more fields here as needed
    }
  } catch (e) {
    log(e.toString());
  }
  runApp(NyxaraApp());
}

class NyxaraApp extends StatelessWidget {
  final GoRouter _router = NyxaraRouter.returnRouter();

  NyxaraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => AuthBloc(nyxaraDB: NyxaraDB()))],
      child: MaterialApp.router(
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
        title: 'Nyxara App',
      ),
    );
  }
}
