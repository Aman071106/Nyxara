import 'package:nyxara/domain/entities/breach_analytics_entity.dart';

abstract class BreachRepository {
  Future<bool> checkBreach(String email);
  Future<AnalyticsEntity?> fetchAnalytics(String email);
}
