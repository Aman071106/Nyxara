import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nyxara/domain/usecases/check_logged_in.dart';
import 'package:nyxara/domain/usecases/getEmail.dart';
import 'package:nyxara/domain/usecases/logout_usecase.dart';
import 'package:nyxara/domain/usecases/signin.dart';
import 'package:nyxara/domain/usecases/signup.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUser signInUser;
  final SignUpUser signUpUser;
  final CheckLoggedIn checkLoggedIn;
  final LogoutUsecase logoutUsecase;
  final Getemail getemail;

  AuthBloc({
    required this.signInUser,
    required this.signUpUser,
    required this.checkLoggedIn,
    required this.logoutUsecase,
    required this.getemail,
  }) : super(AppStartState()) {
    on<LoginRequested>(_onLoginRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<AppStartEvent>(_appStart);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(Logging());

    try {
      final stillLoggedIn = await checkLoggedIn.execute();
      if (stillLoggedIn) {
        final email = await getemail.execute();
        emit(Authenticated(email: email));
        return;
      }

      final user = await signInUser.execute(event.email, event.password);
      if (user != null) {
        emit(Authenticated(email: event.email));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(Unauthenticated());
    }
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(SigningUp());

    try {
      final user = await signUpUser.execute(event.email, event.password);
      if (user != null) {
        emit(SignedUp());
      } else {
        emit(NotSignedUp());
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(NotSignedUp());
      emit(Unauthenticated());
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await logoutUsecase.execute();
    emit(Unauthenticated());
  }

  Future<void> _appStart(AppStartEvent event, Emitter<AuthState> emit) async {
    emit(AppStartState());
    log("Yes here");
    try {
      final isLoggedIn = await checkLoggedIn.execute();
      log("Checking Logged In ${isLoggedIn.toString()}");

      if (isLoggedIn) {
        log("Checking Logged In 2 ${isLoggedIn.toString()}");

        final email = await getemail.execute();
        emit(Authenticated(email: email));
      } else {
        log("Checking Logged In 3 ${isLoggedIn.toString()}");

        emit(Unauthenticated());
      }
    } catch (e) {
      emit(Unauthenticated());
    }
  }
}
