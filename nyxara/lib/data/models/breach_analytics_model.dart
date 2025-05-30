enum Colname { LEVEL2, LEVEL3, UNKNOWN }

Colname colnameFromString(String colname) {
  switch (colname.toLowerCase()) {
    case 'level2':
      return Colname.LEVEL2;
    case 'level3':
      return Colname.LEVEL3;
    default:
      return Colname.UNKNOWN;
  }
}

enum PasswordRisk { EASYTOCRACK, PLAINTEXT, STRONGHASH, UNKNOWN }

PasswordRisk passwordRiskFromString(String s) {
  switch (s.toLowerCase()) {
    case 'easytocrack':
      return PasswordRisk.EASYTOCRACK;
    case 'plaintext':
      return PasswordRisk.PLAINTEXT;
    case 'stronghash':
      return PasswordRisk.STRONGHASH;
    default:
      return PasswordRisk.UNKNOWN;
  }
}

enum RiskLabel { HIGH, MEDIUM, LOW, UNKNOWN }

RiskLabel riskLabelFromString(String s) {
  switch (s.toLowerCase()) {
    case 'high':
      return RiskLabel.HIGH;
    case 'medium':
      return RiskLabel.MEDIUM;
    case 'low':
      return RiskLabel.LOW;
    default:
      return RiskLabel.UNKNOWN;
  }
}

enum GroupLabel { A, B, C, D, F, G, I, UNKNOWN }

GroupLabel groupLabelFromString(String s) {
  switch (s.toUpperCase()) {
    case 'A':
      return GroupLabel.A;
    case 'B':
      return GroupLabel.B;
    case 'C':
      return GroupLabel.C;
    case 'D':
      return GroupLabel.D;
    case 'F':
      return GroupLabel.F;
    case 'G':
      return GroupLabel.G;
    case 'I':
      return GroupLabel.I;
    default:
      return GroupLabel.UNKNOWN;
  }
}

class AnalyticsModel {
  final BreachMetrics breachMetrics;
  final BreachesSummary breachesSummary;

  AnalyticsModel({required this.breachMetrics, required this.breachesSummary});

  factory AnalyticsModel.fromJson(Map<String, dynamic> json) {
    return AnalyticsModel(
      breachMetrics: BreachMetrics.fromJson(json['BreachMetrics'] ?? {}),
      breachesSummary: BreachesSummary.fromJson(json['BreachesSummary'] ?? {}),
    );
  }
}

class BreachMetrics {
  final List<dynamic> getDetails;
  final List<List<List<IndustryData>>> industry;
  final List<PasswordsStrength> passwordsStrength;
  final List<Risk> risk;
  final List<XposedDatum> xposedData;
  final List<Map<String, int>> yearwiseDetails;

  BreachMetrics({
    required this.getDetails,
    required this.industry,
    required this.passwordsStrength,
    required this.risk,
    required this.xposedData,
    required this.yearwiseDetails,
  });

  factory BreachMetrics.fromJson(Map<String, dynamic> json) {
    List<List<List<IndustryData>>> parseIndustry(dynamic data) {
      if (data is List) {
        try {
          return data.map<List<List<IndustryData>>>((lvl1) {
            if (lvl1 is List) {
              return lvl1.map<List<IndustryData>>((lvl2) {
                if (lvl2 is List) {
                  return lvl2.map<IndustryData>((e) {
                    // Defensive: if e is List with length >= 2, parse IndustryData; else skip
                    if (e is List && e.length >= 2) {
                      return IndustryData.fromJson(e);
                    } else {
                      // Provide default fallback
                      return IndustryData('unknown', 0);
                    }
                  }).toList();
                } else {
                  return <IndustryData>[];
                }
              }).toList();
            } else {
              return <List<IndustryData>>[];
            }
          }).toList();
        } catch (e) {
          print('Error parsing industry: $e');
          return <List<List<IndustryData>>>[];
        }
      }
      return <List<List<IndustryData>>>[];
    }

    return BreachMetrics(
      getDetails: json['get_details'] ?? [],
      industry: parseIndustry(json['industry']),
      passwordsStrength:
          (json['passwords_strength'] as List<dynamic>? ?? [])
              .map((e) => PasswordsStrength.fromJson(e))
              .toList(),
      risk:
          (json['risk'] as List<dynamic>? ?? [])
              .map((e) => Risk.fromJson(e))
              .toList(),
      xposedData:
          (json['xposed_data'] as List<dynamic>? ?? [])
              .map((e) => XposedDatum.fromJson(e))
              .toList(),
      yearwiseDetails:
          (json['yearwise_details'] as List<dynamic>? ?? [])
              .map((e) => Map<String, int>.from(e as Map))
              .toList(),
    );
  }
}

class IndustryData {
  final String name;
  final int value;

  IndustryData(this.name, this.value);

  factory IndustryData.fromJson(List<dynamic> json) {
    return IndustryData(json[0] as String, (json[1] as num).toInt());
  }
}

class PasswordsStrength {
  final int easyToCrack;
  final int plainText;
  final int strongHash;
  final int unknown;

  PasswordsStrength({
    required this.easyToCrack,
    required this.plainText,
    required this.strongHash,
    required this.unknown,
  });

  factory PasswordsStrength.fromJson(Map<String, dynamic> json) {
    return PasswordsStrength(
      easyToCrack: json['EasyToCrack'] ?? 0,
      plainText: json['PlainText'] ?? 0,
      strongHash: json['StrongHash'] ?? 0,
      unknown: json['Unknown'] ?? 0,
    );
  }
}

class Risk {
  final RiskLabel riskLabel;
  final int riskScore;

  Risk({required this.riskLabel, required this.riskScore});

  factory Risk.fromJson(Map<String, dynamic> json) {
    return Risk(
      riskLabel: riskLabelFromString(json['risk_label'] ?? ''),
      riskScore: (json['risk_score'] as num?)?.toInt() ?? 0,
    );
  }
}

class XposedDatum {
  final List<XposedCategory> children;

  XposedDatum({required this.children});

  factory XposedDatum.fromJson(Map<String, dynamic> json) {
    return XposedDatum(
      children:
          (json['children'] as List<dynamic>? ?? [])
              .map((e) => XposedCategory.fromJson(e))
              .toList(),
    );
  }
}

class XposedCategory {
  final String name;
  final List<XposedCategory>? children;
  final Colname colname;
  final GroupLabel? group;
  final String? colnameRaw;
  final String? groupRaw;
  final int? value;

  XposedCategory({
    required this.name,
    this.children,
    required this.colname,
    this.group,
    this.colnameRaw,
    this.groupRaw,
    this.value,
  });

  factory XposedCategory.fromJson(Map<String, dynamic> json) {
    return XposedCategory(
      name: json['name'] ?? '',
      children:
          json['children'] != null
              ? (json['children'] as List<dynamic>)
                  .map((e) => XposedCategory.fromJson(e))
                  .toList()
              : null,
      colname:
          json.containsKey('colname')
              ? colnameFromString(json['colname'])
              : Colname.UNKNOWN,
      group:
          json.containsKey('group')
              ? groupLabelFromString(json['group'])
              : null,
      colnameRaw: json['colname'],
      groupRaw: json['group'],
      value: json['value'] is num ? (json['value'] as num).toInt() : null,
    );
  }
}

class BreachesSummary {
  final String site;

  BreachesSummary({required this.site});

  factory BreachesSummary.fromJson(Map<String, dynamic> json) {
    return BreachesSummary(site: json['site'] ?? '');
  }
}
