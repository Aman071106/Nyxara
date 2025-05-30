part of 'breach_bloc.dart';

@immutable
sealed class BreachState {}

final class NotBreached extends BreachState {}

final class CheckingBreach extends BreachState {}

final class Breached extends BreachState {
  final String email;
  Breached({required this.email});
}

final class CheckingAnalytics extends Breached {
  CheckingAnalytics({required super.email});
}

final class AnalyticsFetched extends Breached {
  AnalyticsFetched({required super.email});
}
