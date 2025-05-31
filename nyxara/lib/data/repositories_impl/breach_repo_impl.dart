import 'dart:developer';

import 'package:nyxara/data/datasources/breach_datasource.dart';
import 'package:nyxara/domain/entities/advice_response_entity.dart';
import 'package:nyxara/domain/entities/breach_analytics_entity.dart';
import 'package:nyxara/domain/repositories/breach_repository.dart';

class BreachRepoImpl implements BreachRepository {
  final BreachDatasource breachService = BreachDatasource();
  @override
  Future<AnalyticsEntity?> fetchAnalytics(String email) async {
    try {
      final model = await breachService.fetchBreachAnalytics(email);

      return AnalyticsEntity.fromModel(model!);
    } catch (e) {
      // error
      return null;
    }
  }

  @override
  Future<bool> checkBreach(String email) {
    return breachService.checkBreach(email);
  }

  @override
  Future<AdviceResponseEntity?> fetchAdvice() async {
    try {
      final model = await breachService.fetchAdvice();
      return AdviceResponseEntity.fromAdviceResponseModel(model!);
    } catch (e) {
      log("Error fetching entity in repo_impl : $e");
      return null;
    }
  }
}
