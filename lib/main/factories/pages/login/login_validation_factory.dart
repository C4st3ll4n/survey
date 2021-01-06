import '../../../../validation/protocols/field_validate.dart';
import '../../../../presentation/protocols/protocols.dart';
import '../../../../validation/validators/validators.dart';

Validation makeLoginValidation() => ValidationComposite(
      makeLoginValidations()
    );

List<FieldValidation> makeLoginValidations(){
  return [
      EmailValidation("email"),
      RequiredFieldValidation("email"),
      RequiredFieldValidation("password")
  ];
}