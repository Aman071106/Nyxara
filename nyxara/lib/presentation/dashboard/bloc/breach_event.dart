part of 'breach_bloc.dart';

@immutable
sealed class BreachEvent {}

final class CheckBreach extends BreachEvent {
  final String email;
  CheckBreach({required this.email});
}

final class CheckBreachAnalytics extends BreachEvent {
  final String email;
  CheckBreachAnalytics({required this.email});
}
