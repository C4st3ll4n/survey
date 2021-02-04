import 'package:flutter_test/flutter_test.dart';
import 'package:survey/main/factories/factories.dart';
import 'package:survey/validation/validation.dart';

void main() {
  test(
    "Should return the correct validations",
    () {
      final validations = makeSignUpValidations();
      expect(
        validations,
        [
          RequiredFieldValidation("name"),
          MinLengthFieldValidation(field: "name", minLength: 3),
          RequiredFieldValidation("email"),
          EmailValidation("email"),
          RequiredFieldValidation("password"),
          MinLengthFieldValidation(field: "password", minLength: 3),
          RequiredFieldValidation("passwordConfirmation"),
          CompareFieldValidation(
              field: "passwordConfirmation", fieldToCompare: "password"),
        ],
      );
    },
  );
}
