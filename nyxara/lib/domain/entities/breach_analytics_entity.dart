
// analytics_entity.dart
import 'package:nyxara/data/models/breach_analytics_model.dart';


class XposedDataCategory {
  final String category;
  final List<String> children;
  XposedDataCategory({required this.category, required this.children});
}

class AnalyticsEntity {
  final RiskLabel riskLabel;
  final int riskScore;
  final List<XposedDataCategory> xposedData;
  final List<Map<String, int>> yearwiseDetails;
  final int? exposedCategoryCount;

  AnalyticsEntity({
    required this.riskLabel,
    required this.riskScore,
    required this.xposedData,
    required this.yearwiseDetails,
    this.exposedCategoryCount,
  });

  static AnalyticsEntity fromModel(AnalyticsModel model) {
    final RiskLabel label = model.breachMetrics?.risk.first.riskLabel ?? RiskLabel.LOW;
    final int score = model.breachMetrics?.risk.first.riskScore ?? 0;

    final List<XposedDataCategory> categories = [];
    final rawXposed = model.breachMetrics?.xposedData;
    if (rawXposed != null) {
      for (var item in rawXposed) {
        categories.add(XposedDataCategory(
          category: item.children.first.name,
          children: item.children.map((c) => c.name).toList(),
        ));
      }
    }

    final List<Map<String, int>> yearDetails =
        model.breachMetrics?.yearwiseDetails ?? [];

    final int? exposedCount = model.breachMetrics?.xposedData.length;

    return AnalyticsEntity(
      riskLabel: label,
      riskScore: score,
      xposedData: categories,
      yearwiseDetails: yearDetails,
      exposedCategoryCount: exposedCount,
    );
  }
}
