import '../../../composites/composites.dart';
import '../../../builders/builders.dart';
import '../../../../validation/protocols/field_validate.dart';
import '../../../../presentation/protocols/protocols.dart';

Validation makeSignupValidation() => ValidationComposite(
    makeSignUpValidations()
    );

List<FieldValidation> makeSignUpValidations(){
  return [
   ... ValidationBuilder.field("name").required().min(3).build(),
   ... ValidationBuilder.field("email").required().email().build(),
   ... ValidationBuilder.field("password").required().min(3).build(),
   ... ValidationBuilder.field("passwordConfirmation").required().sameAs("password").build(),
  ];
}