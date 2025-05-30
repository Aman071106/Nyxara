import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nyxara/domain/entities/breach_analytics_entity.dart';
import 'package:nyxara/domain/usecases/check_breach.dart';
import 'package:nyxara/domain/usecases/fetch_analytics.dart';

part 'breach_event.dart';
part 'breach_state.dart';

class BreachBloc extends Bloc<BreachEvent, BreachState> {
  final CheckBreachUsecase checkBreachUseCase;
  final FetchAnalytics fetchAnalyticsUseCase;

  BreachBloc({
    required this.checkBreachUseCase,
    required this.fetchAnalyticsUseCase,
  }) : super(NotBreached()) {
    on<CheckBreach>(_onCheckBreach);
    on<CheckBreachAnalytics>(_onCheckAnalytics);
  }

  Future<void> _onCheckBreach(
    CheckBreach event,
    Emitter<BreachState> emit,
  ) async {
    emit(CheckingBreach());
    try {
      bool isBreached = await checkBreachUseCase.execute(event.email);
      if (isBreached) {
        emit(Breached(email: event.email));
      } else {
        emit(NotBreached());
      }
    } catch (e) {
      log("Error in checking breach: ${e.toString()}");
      emit(NotBreached());
    }
  }

  Future<void> _onCheckAnalytics(
    CheckBreachAnalytics event,
    Emitter<BreachState> emit,
  ) async {
    emit(CheckingAnalytics(email: event.email));
    try {
      final AnalyticsEntity? entity = await fetchAnalyticsUseCase.execute(event.email);
      if (entity != null) {
        emit(AnalyticsFetched(email: event.email, analyticsEntity: entity));
      } else {
        emit(AnalyticsFetchedError());
        log("Error fetching analytics: entity null");
      }
    } catch (e) {
      emit(AnalyticsFetchedError());
      log("Error fetching analytics: ${e.toString()}");
    }
  }
}
