part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AppStartEvent extends AuthEvent {}

final class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested({required this.email, required this.password});
}

final class SignUpRequested extends AuthEvent {
  final String email;
  final String password;

  SignUpRequested({required this.email, required this.password});
}

final class LogoutRequested extends AuthEvent {}

final class SendOTPevent extends AuthEvent {
  final String email;
  SendOTPevent({required this.email});
}
