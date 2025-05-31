part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}
final class AppStartState extends AuthState{}
final class Unauthenticated extends AuthState {}

final class Logging extends AuthState {} // Trying to log in

final class SigningUp extends AuthState {} // Trying to sign up
final class SignedUp extends AuthState{}
final class NotSignedUp extends AuthState{}
final class Authenticated extends AuthState {
  final String email;
  Authenticated({required this.email}); // Useful for tracking logged-in user
}
