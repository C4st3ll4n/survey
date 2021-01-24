import 'package:flutter_test/flutter_test.dart';
import 'package:survey/main/factories/factories.dart';
import 'package:survey/validation/validators/validators.dart';

void main() {
  test("Should return the correct validations", () {
    final validations = makeLoginValidations();
    expect(validations, [
      RequiredFieldValidation("email"),
      EmailValidation("email"),
      RequiredFieldValidation("password"),
      MinLengthFieldValidation(field: "password", minLength: 3)
    ]);
  });
}
