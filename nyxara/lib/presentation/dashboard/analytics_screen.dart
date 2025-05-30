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
            print("Websites in screen");
            print(entity.websites);

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("📊 Risk Level: ${entity.riskLabel.name}"),
                    Text("🔢 Risk Score: ${entity.riskScore}"),
                    const SizedBox(height: 12),

                    Text(
                      "📁 Exposed Categories (${entity.exposedCategoryCount ?? 0}):",
                    ),
                    ...entity.xposedData.map(
                      (category) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //major cateogries of breach
                          ...category.children.map(
                            (child) => Text("   - $child"),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    Text("📅 Year-wise Breach Details:"),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: entity.yearwiseDetails[0].length,
                      itemBuilder:
                          (context, i) => ListTile(
                            title: Text(
                              entity.yearwiseDetails[0].keys.toList()[i],
                            ), //year
                            subtitle: Text(
                              entity
                                  .yearwiseDetails[0][entity
                                      .yearwiseDetails[0]
                                      .keys
                                      .toList()[i]]
                                  .toString(),
                            ),
                          ),
                    ),

                    //website links through which data leaked
                    Text("Websites"),
                    ListView.builder(
                      itemCount: entity.websites.length,
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        return ListTile(title: Text(entity.websites[i]));
                      },
                    ),
                  ],
                ),
              ),
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
