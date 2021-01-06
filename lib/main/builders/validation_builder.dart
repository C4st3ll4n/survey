import '../../validation/protocols/field_validate.dart';
import '../../validation/validators/validators.dart';

class ValidationBuilder {
  static ValidationBuilder _instace;
  String fieldName;
  List<FieldValidation> validations = [];
  
  ValidationBuilder._();

  static ValidationBuilder field(String fieldName) {
    _instace = ValidationBuilder._();
    _instace.fieldName = fieldName;
    return _instace;
  }

  ValidationBuilder required() {
    validations.add(RequiredFieldValidation(_instace.fieldName));
    return this;
  }

  ValidationBuilder email() {
    validations.add(EmailValidation(_instace.fieldName));
    return this;
  }

  List<FieldValidation> build() => validations;
}
