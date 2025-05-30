import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nyxara/domain/repositories/user_repository.dart'; // your data source

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository userRepository;

  AuthBloc({required this.userRepository}) : super(Unauthenticated()) {
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
      final user = await userRepository.signInUser(event.email, event.password);
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
      final user = await userRepository.signUpUser(event.email, event.password);
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
