import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nyxara/core/router/router_config.dart';

void main() {
  runApp(const NyxaraApp());
}

class NyxaraApp extends StatelessWidget {
  const NyxaraApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = NyxaraRouter.returnRouter();
    return MaterialApp.router(routerConfig: router);
  }
}
