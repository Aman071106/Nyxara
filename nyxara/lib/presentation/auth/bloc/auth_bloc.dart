import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nyxara/domain/usecases/signin.dart';
import 'package:nyxara/domain/usecases/signup.dart'; // your data source

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUser signInUser;
  final SignUpUser signUpUser;

  AuthBloc({required this.signInUser,required this.signUpUser}) : super(Unauthenticated()) {
    on<LoginRequested>(_onLoginRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(Logging());
    try {
      final user = await signInUser.execute(event.email, event.password);
      if (user != null) {
        emit(Authenticated(email: event.email));
      } else {
        emit(
          Unauthenticated(),
        ); // Or you can emit a LoginFailed state if you define one
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
        emit(Authenticated(email: user.email));
      } else {
        emit(Unauthenticated()); // Or a separate SignupFailed state
      }
    } catch (e) {
      emit(Unauthenticated());
    }
  }

  void _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) {
    emit(Unauthenticated());
  }
}
