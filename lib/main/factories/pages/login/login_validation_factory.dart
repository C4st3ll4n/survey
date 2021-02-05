import 'package:survey/main/composites/composites.dart';

import '../../../builders/builders.dart';
import '../../../../validation/protocols/field_validate.dart';
import '../../../../presentation/protocols/protocols.dart';

Validation makeLoginValidation() => ValidationComposite(
      makeLoginValidations()
    );

List<FieldValidation> makeLoginValidations(){
  return [
   ... ValidationBuilder.field("email").required().email().build(),
   ... ValidationBuilder.field("password").required().min(3).build(),
  ];
}