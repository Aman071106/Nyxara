import 'dart:developer';

class AdviceResponseModel {
  final List<String> advices;
  final List<String> pieLabels;
  final List<int> piePercentage;

  AdviceResponseModel({
    required this.advices,
    required this.pieLabels,
    required this.piePercentage,
  });

  factory AdviceResponseModel.fromJson(Map<String, dynamic> json) {
    log("Inside AdviceResponseModel Parser");

    try {
      return AdviceResponseModel(
        advices: List<String>.from(json['advices']),
        pieLabels: List<String>.from(json['pie_labels']),
        piePercentage: List<int>.from(json['pie_percentage']),
      );
    } catch (e) {
      log("Error parsing response: $e");
      return AdviceResponseModel(advices: [], pieLabels: [], piePercentage: []);
    }
  }
}
