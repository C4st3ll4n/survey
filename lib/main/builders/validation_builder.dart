
import 'package:survey/validation/validation.dart';

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
  
  ValidationBuilder min(int size) {
    validations.add(MinLengthFieldValidation(field:_instace.fieldName, minLength: size));
    return this;
  }

  ValidationBuilder max(int size) {
    validations.add(MaxLengthFieldValidation(field:_instace.fieldName, maxLength: size));
    return this;
  }

  List<FieldValidation> build() => validations;
}
