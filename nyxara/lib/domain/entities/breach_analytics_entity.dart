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
    final RiskLabel label =
        model.breachMetrics?.risk.first.riskLabel ?? RiskLabel.LOW;
    final int score = model.breachMetrics?.risk.first.riskScore ?? 0;
    // int exposedCount = 0;
    final List<XposedDataCategory> categories = [];
    final rawXposed = model.breachMetrics?.xposedData;
    if (rawXposed != null) {
      for (var item in rawXposed) {
        categories.add(
          XposedDataCategory(
            category: item.children.first.name,
            children: item.children.map((c) => c.name).toList(),
          ),
        );
      }
    }

    final List<Map<String, int>> yearDetails =
        model.breachMetrics?.yearwiseDetails ?? [];

    // final int? exposedCount = model.breachMetrics?.xposedData[0].length;
    //logging
    print("riskLabel: $label");
    print("Score: $score");
    // print("$exposedCount");
    print("------Cateogries----");
    for (int i = 0; i < categories.length; i++) {
      print("${categories[i].category}");
      print("${categories[i].children}");
    }
    print("---Year details---");
    print(yearDetails[0]);
    //conclusion:yearDetails[0]:{y2007: 0, y2008: 0, y2009: 0, y2010: 0, y2011: 0, y2012: 14, y2013: 8, y2014: 2, y2015: 4, y2016: 26, y2017:
    // 16, y2018: 30, y2019: 34, y2020: 40, y2021: 28, y2022: 8, y2023: 14, y2024: 14, y2025: 0}
    //that is a map contain year as key and corresponding no of incident as value

    return AnalyticsEntity(
      riskLabel: label,
      riskScore: score,
      xposedData: categories,
      yearwiseDetails: yearDetails,
      exposedCategoryCount: categories[0].children.length,
    );
  }
}
