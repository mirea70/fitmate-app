import 'dart:convert';

// MateListRequestModel mateListRequestModelFromJson(String str) => MateListRequestModel.fromJson(json.decode(str));
String mateListRequestModelToJson(MateListRequestModel data) => json.encode(data.toJson());

class MateListRequestModel {
  final int? dayOfWeek;
  final DateTime? startMateAt;
  final DateTime? endMateAt;
  final List<String> fitPlaceRegions;
  final int? permitMaxAge;
  final int? permitMinAge;
  final int? startLimitPeopleCnt;
  final int? endLimitPeopleCnt;
  final FitCategory fitCategory;


  MateListRequestModel({
      this.dayOfWeek,
      this.startMateAt,
      this.endMateAt,
      required this.fitPlaceRegions,
      this.permitMaxAge,
      this.permitMinAge,
      this.startLimitPeopleCnt,
      this.endLimitPeopleCnt,
      required this.fitCategory
  });

  factory MateListRequestModel.initial() {
    return MateListRequestModel(
      fitPlaceRegions: [],
      fitCategory: FitCategory.undefined,
      permitMinAge: 20,
      permitMaxAge: 50,
      startLimitPeopleCnt: 3,
      endLimitPeopleCnt: 50,
    );
  }

  MateListRequestModel copyWith({
    int? dayOfWeek,
    DateTime? startMateAt,
    DateTime? endMateAt,
    List<String>? fitPlaceRegions,
    int? permitMaxAge,
    int? permitMinAge,
    int? startLimitPeopleCnt,
    int? endLimitPeopleCnt,
    FitCategory? fitCategory,
  }) =>
      MateListRequestModel(
        dayOfWeek: dayOfWeek ?? this.dayOfWeek,
        startMateAt: startMateAt ?? this.startMateAt,
        endMateAt: endMateAt ?? this.endMateAt,
        fitPlaceRegions: fitPlaceRegions ?? this.fitPlaceRegions,
        permitMaxAge: permitMaxAge ?? this.permitMaxAge,
        permitMinAge: permitMinAge ?? this.permitMinAge,
        startLimitPeopleCnt: startLimitPeopleCnt ?? this.startLimitPeopleCnt,
        endLimitPeopleCnt: endLimitPeopleCnt ?? this.endLimitPeopleCnt,
        fitCategory: fitCategory ?? this.fitCategory,
      );

  // factory MateListRequestModel.fromJson(Map<String, dynamic> json) => MateListRequestModel(
  //   dayOfWeek: json["dayOfWeek"],
  //   startMateAt: json["startMateAt"] == null ? null : DateTime.parse(json["startMateAt"]),
  //   endMateAt: json["endMateAt"] == null ? null : DateTime.parse(json["endMateAt"]),
  //   fitPlaceRegions: json["fitPlaceRegions"] == null ? [] : List<String>.from(json["fitPlaceRegions"]!.map((x) => x)),
  //   permitMaxAge: json["permitMaxAge"],
  //   permitMinAge: json["permitMinAge"],
  //   startLimitPeopleCnt: json["startLimitPeopleCnt"],
  //   endLimitPeopleCnt: json["endLimitPeopleCnt"],
  //   fitCategory: json["fitCategory"],
  // );

  Map<String, dynamic> toJson() => {
    "dayOfWeek": dayOfWeek == -1 ? null : dayOfWeek,
    "startMateAt": startMateAt?.toIso8601String(),
    "endMateAt": endMateAt?.toIso8601String(),
    "fitPlaceRegions": List<dynamic>.from(fitPlaceRegions!.map((x) => x)),
    "permitMaxAge": permitMaxAge,
    "permitMinAge": permitMinAge,
    "startLimitPeopleCnt": startLimitPeopleCnt,
    "endLimitPeopleCnt": endLimitPeopleCnt,
    "fitCategory": fitCategory == FitCategory.undefined ? null : fitCategory.name,
  };
}


enum FitCategory {
  FITNESS('FITNESS','헬스'),
  CROSSFIT('CROSSFIT', '크로스핏'),
  undefined('undefined', '');

  final String code;
  final String label;
  const FitCategory(this.code, this.label);

  factory FitCategory.getByCode(String code) {
    return FitCategory.values.firstWhere((value) => value.code == code,
        orElse: () => FitCategory.undefined);
  }
}