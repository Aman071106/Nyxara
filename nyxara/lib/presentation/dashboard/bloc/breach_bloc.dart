import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'breach_event.dart';
part 'breach_state.dart';

class BreachBloc extends Bloc<BreachEvent, BreachState> {
  BreachBloc() : super(NotBreached()) {
    on<CheckBreach>(_checkBreach);
    on<CheckBreachAnalytics>(_checkAnalytics);
  }

  FutureOr<void> _checkBreach(CheckBreach event, Emitter<BreachState> emit) {
  }

  FutureOr<void> _checkAnalytics(CheckBreachAnalytics event, Emitter<BreachState> emit) {
  }
}
