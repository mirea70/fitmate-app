class AccountJoinError {
  final String? loginNameError;
  final String? passwordError;
  final String? checkPasswordError;
  final String? nickNameError;
  final String? nameError;
  final String? phoneError;
  final String? emailError;

  const AccountJoinError({
    this.loginNameError,
    this.passwordError,
    this.checkPasswordError,
    this.nickNameError,
    this.nameError,
    this.phoneError,
    this.emailError,
  });

  AccountJoinError copyWith({
    String? Function()? loginNameError,
    String? Function()? passwordError,
    String? Function()? checkPasswordError,
    String? Function()? nickNameError,
    String? Function()? nameError,
    String? Function()? phoneError,
    String? Function()? emailError,
  }) {
    return AccountJoinError(
      loginNameError: loginNameError != null ? loginNameError() : this.loginNameError,
      passwordError: passwordError != null ? passwordError() : this.passwordError,
      checkPasswordError: checkPasswordError != null ? checkPasswordError() : this.checkPasswordError,
      nickNameError: nickNameError != null ? nickNameError() : this.nickNameError,
      nameError: nameError != null ? nameError() : this.nameError,
      phoneError: phoneError != null ? phoneError() : this.phoneError,
      emailError: emailError != null ? emailError() : this.emailError,
    );
  }
}
