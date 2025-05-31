part of 'breach_bloc.dart';

@immutable
sealed class BreachState {}

final class NotBreached extends BreachState {}

final class CheckingBreach extends BreachState {}

final class Breached extends BreachState {
  final String email;
  Breached({required this.email});
}

final class CheckingAnalytics extends BreachState {
  final String email;
  CheckingAnalytics({required this.email});
}

final class AnalyticsFetched extends BreachState {
  final String email;
  final AnalyticsEntity analyticsEntity;
  final AdviceResponseEntity adviceResponseEntity;
  AnalyticsFetched({
    required this.email,
    required this.analyticsEntity,
    required this.adviceResponseEntity,
  });
}

final class AnalyticsFetchedError extends BreachState {}
