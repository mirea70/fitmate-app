import 'dart:convert';

import 'package:flutter/material.dart';

Mate mateFromJson(String str) => Mate.fromJson(json.decode(str));

String mateToJson(Mate data) => json.encode(data.toJson());

class Mate {
  final FitCategory? fitCategory;
  final String title;
  final String introduction;
  final List<int> introImageIds;
  final DateTime? mateAt;
  final String fitPlaceName;
  final String fitPlaceAddress;
  final GatherType? gatherType;
  final PermitGender? permitGender;
  final int? permitMaxAge;
  final int? permitMinAge;
  final int? permitPeopleCnt;
  final List<MateFee> mateFees;
  final int? totalFee;
  final String applyQuestion;
  final List<int> waitingAccountIds;
  final List<int> approvedAccountIds;

  Mate({
    required this.fitCategory,
    required this.title,
    required this.introduction,
    required this.introImageIds,
    required this.mateAt,
    required this.fitPlaceName,
    required this.fitPlaceAddress,
    required this.gatherType,
    required this.permitGender,
    required this.permitMaxAge,
    required this.permitMinAge,
    required this.permitPeopleCnt,
    required this.mateFees,
    required this.totalFee,
    required this.applyQuestion,
    required this.waitingAccountIds,
    required this.approvedAccountIds,
  });

  factory Mate.initial() {
    final defaultDate = DateTime.now().add(Duration(days: 3));
    final defaultTime = TimeOfDay(hour: 18, minute: 0);
    final selectDateTime = DateTime(defaultDate.year, defaultDate.month, defaultDate.day, defaultTime.hour, defaultTime.minute);

    return Mate(
      fitCategory: null,
      title: '',
      introduction: '',
      introImageIds: [],
      mateAt: selectDateTime,
      fitPlaceName: '',
      fitPlaceAddress: '',
      gatherType: GatherType.FAST,
      permitGender: PermitGender.ALL,
      permitMaxAge: 50,
      permitMinAge: 20,
      permitPeopleCnt: 3,
      mateFees: [],
      totalFee: 0,
      applyQuestion: '',
      waitingAccountIds: [],
      approvedAccountIds: [],
    );
  }

  Mate copyWith({
    FitCategory? fitCategory,
    String? title,
    String? introduction,
    List<int>? introImageIds,
    DateTime? mateAt,
    String? fitPlaceName,
    String? fitPlaceAddress,
    GatherType? gatherType,
    PermitGender? permitGender,
    int? permitMaxAge,
    int? permitMinAge,
    int? permitPeopleCnt,
    List<MateFee>? mateFees,
    int? totalFee,
    String? applyQuestion,
    List<int> ? waitingAccountIds,
    List<int> ? approvedAccountIds,
  }) =>
      Mate(
        fitCategory: fitCategory ?? this.fitCategory,
        title: title ?? this.title,
        introduction: introduction ?? this.introduction,
        introImageIds: introImageIds ?? this.introImageIds,
        mateAt: mateAt ?? this.mateAt,
        fitPlaceName: fitPlaceName ?? this.fitPlaceName,
        fitPlaceAddress: fitPlaceAddress ?? this.fitPlaceAddress,
        gatherType: gatherType ?? this.gatherType,
        permitGender: permitGender ?? this.permitGender,
        permitMaxAge: permitMaxAge ?? this.permitMaxAge,
        permitMinAge: permitMinAge ?? this.permitMinAge,
        permitPeopleCnt: permitPeopleCnt ?? this.permitPeopleCnt,
        mateFees: mateFees ?? this.mateFees,
        totalFee: totalFee ?? this.totalFee,
        applyQuestion: applyQuestion ?? this.applyQuestion,
        waitingAccountIds: waitingAccountIds ?? this.waitingAccountIds,
        approvedAccountIds: approvedAccountIds ?? this.approvedAccountIds,
      );

  factory Mate.fromJson(Map<String, dynamic> json) => Mate(
    fitCategory: FitCategory.getByCode(json["fitCategory"]),
    title: json["title"],
    introduction: json["introduction"] != null ? json["introduction"] : '',
    introImageIds: json["introImageIds"] != null ? List<int>.from(json["introImageIds"].map((x) => x as int)) : [],
    mateAt: DateTime.parse(json["mateAt"]),
    fitPlaceName: json["fitPlaceName"],
    fitPlaceAddress: json["fitPlaceAddress"],
    gatherType: GatherType.getByCode(json["gatherType"]),
    permitGender: PermitGender.valueOf(json["permitGender"]),
    permitMaxAge: json["permitMaxAge"],
    permitMinAge: json["permitMinAge"],
    permitPeopleCnt: json["permitPeopleCnt"],
    mateFees: json["mateFees"] != null ? List<MateFee>.from(json["mateFees"].map((x) => MateFee.fromJson(x))) : [],
    totalFee: json["totalFee"] != null ? json["totalFee"] as int : 0,
    applyQuestion: json["applyQuestion"] != null ? json["applyQuestion"] : '',
    waitingAccountIds: List<int>.from(json['waitingAccountIds'].map((x) => x)),
    approvedAccountIds: List<int>.from(json['approvedAccountIds'].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "fitCategory": fitCategory!.name,
    "title": title,
    "introduction": introduction,
    "introImageIds": List<dynamic>.from(introImageIds.map((x) => x)),
    "mateAt": mateAt!.toIso8601String(),
    "fitPlaceName": fitPlaceName,
    "fitPlaceAddress": fitPlaceAddress,
    "gatherType": gatherType!.name,
    "permitGender": permitGender!.name,
    "permitMaxAge": permitMaxAge,
    "permitMinAge": permitMinAge,
    "permitPeopleCnt": permitPeopleCnt,
    "mateFees": List<dynamic>.from(mateFees.map((x) => x.toJson())),
    "totalFee": totalFee,
    "applyQuestion": applyQuestion,
    "waitingAccountIds": List<dynamic>.from(waitingAccountIds.map((x) => x)),
    "approvedAccountIds": List<dynamic>.from(approvedAccountIds.map((x) => x)),
  };
}

class MateFee {
  final String name;
  final int fee;

  MateFee({
    required this.name,
    required this.fee,
  });

  MateFee copyWith({
    String? name,
    int? fee,
  }) =>
      MateFee(
        name: name ?? this.name,
        fee: fee ?? this.fee,
      );

  factory MateFee.fromJson(Map<String, dynamic> json) => MateFee(
    name: json["name"],
    fee: json["fee"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "fee": fee,
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

enum GatherType {
  FAST('FAST', '선착순'),
  AGREE('AGREE', '승인제'),
  undefined('undefined', '');

  final String code;
  final String label;
  const GatherType(this.code, this.label);

  factory GatherType.getByCode(String code) {
    return GatherType.values.firstWhere((value) => value.code == code,
        orElse: () => GatherType.undefined);
  }
}

enum PermitGender {
  ALL,
  MALE,
  FEMALE;

  factory PermitGender.valueOf(String code) {
    PermitGender result = PermitGender.ALL;
    switch (code) {
      case 'ALL': result = PermitGender.ALL;
      break;
      case 'MALE': result = PermitGender.MALE;
      break;
      case 'FEMALE': result = PermitGender.FEMALE;
      break;
    }
    return result;
  }
}