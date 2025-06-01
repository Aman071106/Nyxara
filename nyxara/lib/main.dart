import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:nyxara/core/router/router_config.dart';
import 'package:nyxara/data/datasources/auth_shared_preference_datasource.dart';
import 'package:nyxara/data/datasources/breach_datasource.dart';
import 'package:nyxara/data/datasources/user_datasource.dart';
import 'package:nyxara/data/datasources/vault_datasource.dart';
import 'package:nyxara/data/repositories_impl/breach_repo_impl.dart';
import 'package:nyxara/data/repositories_impl/user_repo_impl.dart';
import 'package:nyxara/data/repositories_impl/vault_repo_impl.dart';
import 'package:nyxara/domain/usecases/check_breach.dart';
import 'package:nyxara/domain/usecases/check_logged_in.dart';
import 'package:nyxara/domain/usecases/check_vault_usecase.dart';
import 'package:nyxara/domain/usecases/create_vault_usecase.dart';
import 'package:nyxara/domain/usecases/fetch_advice.dart';
import 'package:nyxara/domain/usecases/fetch_analytics.dart';
import 'package:nyxara/domain/usecases/fetch_vault_items_usecase.dart';
import 'package:nyxara/domain/usecases/getEmail.dart';
import 'package:nyxara/domain/usecases/logout_usecase.dart';
import 'package:nyxara/domain/usecases/send_otp.dart';
import 'package:nyxara/domain/usecases/signin.dart';
import 'package:nyxara/domain/usecases/signup.dart';
import 'package:nyxara/domain/usecases/verify_masterkey_usecase.dart';
import 'package:nyxara/presentation/auth/bloc/auth_bloc.dart';
import 'package:nyxara/presentation/dashboard/bloc/breach_bloc.dart';
import 'package:nyxara/presentation/vault/bloc/vault_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  String postgreurl = dotenv.env['POSTGRE_URL']!;
  String annonKey = dotenv.env['ANNON_KEY']!;
  List<int> nonce =
      dotenv.env['NONCE']!
          .split(',')
          .map((entry) => int.parse(entry.trim()))
          .toList();
  String tableName = dotenv.env['TABLE_NAME']!;
  String verificationPass = dotenv.env['VERIFICATION_PASS']!;
  await Supabase.initialize(url: postgreurl, anonKey: annonKey);

  runApp(
    NyxaraApp(
      nonce: nonce,
      verificationPass: verificationPass,
      tableName: tableName,
    ),
  );
}

class NyxaraApp extends StatelessWidget {
  final List<int> nonce;
  final String verificationPass;
  final String tableName;

  NyxaraApp({
    super.key,
    required this.nonce,
    required this.verificationPass,
    required this.tableName,
  });

  final GoRouter _router = NyxaraRouter.returnRouter();

  @override
  Widget build(BuildContext context) {
    //create here to avoid multiple instances
    final nyxaraDB = NyxaraDB();
    final sharedAuth = AuthLocalDataSource();
    final userRepository = UserRepositoryImpl(nyxaraDB, sharedAuth);
    final breachDatasource = BreachDatasource();
    final breachRepository = BreachRepoImpl(breachService: breachDatasource);
    final vaultDatasource = VaultDatasource(
      nonce: nonce,
      verificationPass: verificationPass,
      tableName: tableName,
    );
    final vaultRepository = VaultRepoImpl(vaultService: vaultDatasource);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) => VaultBloc(
                checkvaultusecase: Checkvaultusecase(
                  vaultRepository: vaultRepository,
                ),
                createvaultusecase: Createvaultusecase(
                  vaultRepository: vaultRepository,
                ),
                fetchVaultItemsUsecase: FetchVaultItemsUsecase(
                  vaultRepository: vaultRepository,
                ),
                verifyMasterkeyUsecase: VerifyMasterkeyUsecase(
                  vaultRepository: vaultRepository,
                ),
              ),
        ),
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
