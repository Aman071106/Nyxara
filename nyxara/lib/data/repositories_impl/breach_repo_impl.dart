import 'package:nyxara/data/datasources/breach_datasource.dart';
import 'package:nyxara/domain/entities/breach_analytics_entity.dart';
import 'package:nyxara/domain/repositories/breach_repository.dart';

class BreachRepoImpl implements BreachRepository {
  final BreachDatasource breachService = BreachDatasource();
  @override
  Future<AnalyticsEntity?> fetchAnalytics(String email) async {
    // BreachRepository breachService = BreachRepository();
    try {
      final model = await breachService.fetchBreachAnalytics(email);

      return AnalyticsEntity.fromModel(model!);
    } catch (e) {
      // Handle or log the error as needed
      return null;
    }
  }

  @override
  Future<bool> checkBreach(String email) {
    return breachService.checkBreach(email);
  }
}
