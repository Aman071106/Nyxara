import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:nyxara/core/router/routes_consts.dart';
import 'package:nyxara/presentation/auth/auth_screen.dart';
import 'package:nyxara/presentation/dashboard/analytics_screen.dart';
import 'package:nyxara/presentation/home/home_screen.dart';
import 'package:nyxara/presentation/profile/profile_screen.dart';
import 'package:nyxara/presentation/vault/vault_screen.dart';

class NyxaraRouter {
  static GoRouter returnRouter() {
    GoRouter router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          name: NyxaraRoutes.homePageRoute,
          path: '/',
          pageBuilder: (context, state) {
            return MaterialPage(child: HomeScreen());
          },
        ),
        GoRoute(
          name: NyxaraRoutes.loginPageRoute,
          path: '/login',
          pageBuilder: (context, state) {
            return MaterialPage(child: AuthScreen());
          },
        ),
        GoRoute(
          name: NyxaraRoutes.dashboardRoute,
          path: '/analytics',
          pageBuilder: (context, state) {
            return MaterialPage(child: DashBoardScreen());
          },
        ),
        GoRoute(
          name: NyxaraRoutes.vaultRoute,
          path: '/vault',
          pageBuilder: (context, state) {
            return MaterialPage(child: VaultScreen());
          },
        ),
        GoRoute(
          name: NyxaraRoutes.profileRoute,
          path: '/profile',
          pageBuilder: (context, state) {
            return MaterialPage(child: ProfileScreen());
          },
        ),
      ],
    );
    return router;
  }
}
