import '../protocols/protocols.dart';

class EmailValidation implements FieldValidation {
  EmailValidation(this.field);

  final String field;

  @override
  String validate(String value) {
    final RegExp regExp = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    final isValid = value?.isNotEmpty != true || regExp.hasMatch(value);
    return isValid ? null : "Campo inválido.";
  }
}
