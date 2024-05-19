import 'package:freezed_annotation/freezed_annotation.dart';

part 'TokenResponse.freezed.dart';
part 'TokenResponse.g.dart';

@freezed
abstract class TokenResponse with _$TokenResponse {
  const factory TokenResponse({
    required String accessToken,
  }) = _TokenResponse;

  factory TokenResponse.fromJson(Map<String, dynamic> json) =>
      _$TokenResponseFromJson(json);
}