class AccountJoinError {
  String? _passwordError;
  String? _checkPasswordError;
  String? _nickNameError;
  String? _nameError;
  String? _phoneError;
  String? _emailError;

  set passwordError(String? value) {
    _passwordError = value;
  }

  set checkPasswordError(String? value) {
    _checkPasswordError = value;
  }

  set nickNameError(String? value) {
    _nickNameError = value;
  }

  set emailError(String? value) {
    _emailError = value;
  }

  set phoneError(String? value) {
    _phoneError = value;
  }

  set nameError(String? value) {
    _nameError = value;
  }

  String? get passwordError => _passwordError;

  String? get checkPasswordError => _checkPasswordError;

  String? get nickNameError => _nickNameError;

  String? get nameError => _nameError;

  String? get phoneError => _phoneError;

  String? get emailError => _emailError;
}

