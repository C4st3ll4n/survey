import 'package:survey/main/builders/builders.dart';

import '../../../../validation/protocols/field_validate.dart';
import '../../../../presentation/protocols/protocols.dart';
import '../../../../validation/validators/validators.dart';

Validation makeSignupValidation() => ValidationComposite(
    makeSignUpValidations()
    );

List<FieldValidation> makeSignUpValidations(){
  return [
   ... ValidationBuilder.field("name").required().build(),
   ... ValidationBuilder.field("email").required().email().build(),
   ... ValidationBuilder.field("password").required().build(),
  ];
}