class User {
  String _cpf;
  String _password;

  User(this._cpf, this._password);

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  String get cpf => _cpf;

  set cpf(String value) {
    _cpf = value;
  }

}