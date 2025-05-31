import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:nyxara/core/router/router_config.dart';
import 'package:nyxara/data/datasources/auth_shared_preference_datasource.dart';
import 'package:nyxara/data/datasources/user_datasource.dart';
import 'package:nyxara/data/repositories_impl/breach_repo_impl.dart';
import 'package:nyxara/data/repositories_impl/user_repo_impl.dart';
import 'package:nyxara/domain/usecases/check_breach.dart';
import 'package:nyxara/domain/usecases/check_logged_in.dart';
import 'package:nyxara/domain/usecases/fetch_advice.dart';
import 'package:nyxara/domain/usecases/fetch_analytics.dart';
import 'package:nyxara/domain/usecases/getEmail.dart';
import 'package:nyxara/domain/usecases/logout_usecase.dart';
import 'package:nyxara/domain/usecases/send_otp.dart';
import 'package:nyxara/domain/usecases/signin.dart';
import 'package:nyxara/domain/usecases/signup.dart';
import 'package:nyxara/presentation/auth/bloc/auth_bloc.dart';
import 'package:nyxara/presentation/dashboard/bloc/breach_bloc.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  
  runApp(NyxaraApp());
}

class NyxaraApp extends StatelessWidget {
  NyxaraApp({super.key});

  final GoRouter _router = NyxaraRouter.returnRouter();

  @override
  Widget build(BuildContext context) {
    final nyxaraDB = NyxaraDB();
    final sharedAuth = AuthLocalDataSource();
    final userRepository = UserRepositoryImpl(nyxaraDB, sharedAuth);
    final breachRepository = BreachRepoImpl();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) => AuthBloc(
                signInUser: SignInUser(userRepository),
                signUpUser: SignUpUser(userRepository),
                logoutUsecase: LogoutUsecase(userRepository),
                checkLoggedIn: CheckLoggedIn(userRepository),
                getemail: Getemail(userRepository),
                sendOtp: SendOtp(userRepository: userRepository),
              )..add(AppStartEvent()), // Safe trigger here
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
                fetchAdvice: FetchAdvice(breachRepository: breachRepository),
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
