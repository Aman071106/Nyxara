import 'package:nyxara/domain/entities/breach_analytics_entity.dart';
import 'package:nyxara/domain/repositories/breach_repository.dart';

class FetchAnalytics {
  final BreachRepository breachRepository;
  FetchAnalytics({required this.breachRepository});

  Future<AnalyticsEntity?> execute(String email) async {
    return breachRepository.fetchAnalytics(email);
  }
}
