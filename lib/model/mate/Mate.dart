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
  final String applyQuestion;

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
    required this.applyQuestion,
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
      gatherType: null,
      permitGender: null,
      permitMaxAge: null,
      permitMinAge: null,
      permitPeopleCnt: null,
      mateFees: [],
      applyQuestion: ''
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
    String? applyQuestion,
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
        applyQuestion: applyQuestion ?? this.applyQuestion,
      );

  factory Mate.fromJson(Map<String, dynamic> json) => Mate(
    fitCategory: json["fitCategory"],
    title: json["title"],
    introduction: json["introduction"],
    introImageIds: List<int>.from(json["introImageIds"].map((x) => x)),
    mateAt: DateTime.parse(json["mateAt"]),
    fitPlaceName: json["fitPlaceName"],
    fitPlaceAddress: json["fitPlaceAddress"],
    gatherType: json["gatherType"],
    permitGender: json["permitGender"],
    permitMaxAge: json["permitMaxAge"],
    permitMinAge: json["permitMinAge"],
    permitPeopleCnt: json["permitPeopleCnt"],
    mateFees: List<MateFee>.from(json["mateFees"].map((x) => MateFee.fromJson(x))),
    applyQuestion: json["applyQuestion"],
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
    "applyQuestion": applyQuestion,
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
  FITNESS,
  CROSSFIT,
}

enum GatherType {
  FAST,
  AGREE,
}

enum PermitGender {
  ALL,
  MALE,
  FEMALE,
}