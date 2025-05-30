import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nyxara/core/router/routes_consts.dart';
import 'package:nyxara/presentation/auth/bloc/auth_bloc.dart';
import 'package:nyxara/presentation/common/navbar.dart';
import 'package:nyxara/presentation/dashboard/bloc/breach_bloc.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});
  @override
  createState() => _DashBoardScreen();
}

class _DashBoardScreen extends State<DashBoardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthBloc>().state;
      if (authState is! Authenticated) {
        context.goNamed(NyxaraRoutes.loginPageRoute);
      } else {
        context.read<BreachBloc>().add(CheckBreach(email: authState.email));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NyxaraNavbar(title: "Dashboard"),
      body: BlocConsumer<BreachBloc, BreachState>(
        builder: (context, state) {
          if (state is NotBreached) {
            return Center(child: Text("You are safe, Congrats"));
          }
          if (state is CheckingBreach) {
            return Center(
              child: CircularProgressIndicator(semanticsLabel: "Checking..."),
            );
          } else if (state is AnalyticsFetchedError) {
            return Center(
              child: Text("Error fetching analytics but you are breached"),
            );
          } else if (state is CheckingAnalytics) {
            return Center(
              child: CircularProgressIndicator(
                semanticsLabel: "Fetching analytics...",
              ),
            );
          } else if (state is AnalyticsFetched) {
            final entity = state.analyticsEntity;
            final xposedText =
                (entity.xposedData.isNotEmpty &&
                        entity.xposedData[0].children.isNotEmpty)
                    ? entity.xposedData[0].children[0]
                    : "No data available";

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(children: [Text(xposedText)]),
            );
          }
          return Center(child: Text("Unknown error"));
        },
        listener: (context, state) {
          if (state is Breached) {
            print("Breached and checking analytics...");
            context.read<BreachBloc>().add(
              CheckBreachAnalytics(email: state.email),
            );
          }
        },
      ),
    );
  }
}
