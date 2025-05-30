import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nyxara/core/router/router_config.dart';
import 'package:nyxara/data/datasources/user_datasource.dart';
import 'package:nyxara/data/repositories_impl/breach_repo_impl.dart';
import 'package:nyxara/data/repositories_impl/user_repo_impl.dart';
import 'package:nyxara/domain/usecases/check_breach.dart';
import 'package:nyxara/domain/usecases/fetch_analytics.dart';
import 'package:nyxara/domain/usecases/signin.dart';
import 'package:nyxara/domain/usecases/signup.dart';
import 'package:nyxara/presentation/auth/bloc/auth_bloc.dart';
import 'package:nyxara/presentation/dashboard/bloc/breach_bloc.dart';

void main() async {
  runApp(NyxaraApp());
}

class NyxaraApp extends StatelessWidget {
  final GoRouter _router = NyxaraRouter.returnRouter();

  NyxaraApp({super.key});

  @override
  Widget build(BuildContext context) {
    final nyxaraDB = NyxaraDB();
    final userRepository = UserRepositoryImpl(nyxaraDB);
    final breachRepository = BreachRepoImpl();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) => AuthBloc(
                signInUser: SignInUser(userRepository),
                signUpUser: SignUpUser(userRepository),
              ),
        ),
        BlocProvider(
          create:
              (_) => BreachBloc(
                checkBreachUseCase: CheckBreachUsecase(
                  breachRepository: breachRepository,
                ),
                fetchAnalyticsUseCase: FetchAnalytics(
                  breachRepository: breachRepository,
                ),
              ),
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
