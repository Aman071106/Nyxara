import 'package:nyxara/data/models/advice_response_model.dart';
import 'dart:developer';

class AdviceResponseEntity {
  final List<String> advices;
  final List<String> pieLabels;
  final List<int> piePercentage;

  AdviceResponseEntity({
    required this.advices,
    required this.pieLabels,
    required this.piePercentage,
  });

  static AdviceResponseEntity fromAdviceResponseModel(
    AdviceResponseModel model,
  ) {
    log("Inside AdviceResponseEntity Parser");
    print(model.advices);
    print(model.pieLabels);
    print(model.piePercentage);
    return AdviceResponseEntity(
      advices: model.advices,
      pieLabels: model.pieLabels,
      piePercentage: model.piePercentage,
    );
  }
}
