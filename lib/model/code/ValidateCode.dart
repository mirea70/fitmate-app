class ValidateCode {
  final bool isVisibleCheckView;
  final String? code;
  final bool isChecked;

  const ValidateCode({this.isVisibleCheckView = false, this.code, this.isChecked = false});

  ValidateCode copyWith({
    bool? isVisibleCheckView,
    String? Function()? code,
    bool? isChecked,
  }) {
    return ValidateCode(
      isVisibleCheckView: isVisibleCheckView ?? this.isVisibleCheckView,
      code: code != null ? code() : this.code,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}
