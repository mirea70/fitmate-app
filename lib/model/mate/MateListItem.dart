import 'dart:convert';

List<MateListItem> mateListItemFromJson(String str) => List<MateListItem>.from(json.decode(str).map((x) => MateListItem.fromJson(x)));

String mateListItemToJson(List<MateListItem> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MateListItem {
  final int id;
  final int? thumbnailImageId;
  final int? writerImageId;
  final String writerNickName;
  final FitCategory fitCategory;
  final String title;
  final String fitPlaceAddress;
  final DateTime mateAt;
  final GatherType gatherType;
  final PermitGender permitGender;
  final int permitPeopleCnt;
  final int approvedAccountCnt;

  MateListItem({
    required this.id,
    this.thumbnailImageId,
    this.writerImageId,
    required this.writerNickName,
    required this.fitCategory,
    required this.title,
    required this.fitPlaceAddress,
    required this.mateAt,
    required this.gatherType,
    required this.permitGender,
    required this.permitPeopleCnt,
    required this.approvedAccountCnt,
  });

  MateListItem copyWith({
    int? id,
    int? thumbnailImageId,
    int? writerImageId,
    String? writerNickName,
    FitCategory? fitCategory,
    String? title,
    String? fitPlaceAddress,
    DateTime? mateAt,
    GatherType? gatherType,
    PermitGender? permitGender,
    int? permitPeopleCnt,
    int? approvedAccountCnt,
  }) =>
      MateListItem(
        id: id ?? this.id,
        thumbnailImageId: thumbnailImageId ?? this.thumbnailImageId,
        writerImageId: writerImageId ?? this.writerImageId,
        writerNickName: writerNickName ?? this.writerNickName,
        fitCategory: fitCategory ?? this.fitCategory,
        title: title ?? this.title,
        fitPlaceAddress: fitPlaceAddress ?? this.fitPlaceAddress,
        mateAt: mateAt ?? this.mateAt,
        gatherType: gatherType ?? this.gatherType,
        permitGender: permitGender ?? this.permitGender,
        permitPeopleCnt: permitPeopleCnt ?? this.permitPeopleCnt,
        approvedAccountCnt: approvedAccountCnt ?? this.approvedAccountCnt,
      );

  factory MateListItem.fromJson(Map<String, dynamic> json) => MateListItem(
    id: json["id"],
    thumbnailImageId: json["thumbnailImageId"],
    writerImageId: json["writerImageId"],
    writerNickName: json["writerNickName"],
    fitCategory: FitCategory.getByCode(json["fitCategory"]),
    title: json["title"],
    fitPlaceAddress: json["fitPlaceAddress"],
    mateAt: DateTime.parse(json["mateAt"]),
    gatherType: GatherType.getByCode(json["gatherType"]),
    permitGender: PermitGender.valueOf(json["permitGender"]),
    permitPeopleCnt: json["permitPeopleCnt"],
    approvedAccountCnt: json["approvedAccountCnt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "thumbnailImageId": thumbnailImageId,
    "writerImageId": writerImageId,
    "writerNickName": writerNickName,
    "fitCategory": fitCategory.name,
    "title": title,
    "fitPlaceAddress": fitPlaceAddress,
    "mateAt": mateAt.toIso8601String(),
    "gatherType": gatherType.name,
    "permitGender": permitGender.name,
    "permitPeopleCnt": permitPeopleCnt,
    "approvedAccountCnt": approvedAccountCnt,
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