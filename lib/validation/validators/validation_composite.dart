import '../protocols/protocols.dart';
import '../../presentation/protocols/protocols.dart';

class ValidationComposite implements Validation {
	ValidationComposite(this.validations);
	
	final List<FieldValidation> validations;
	
	@override
	ValidationError validate({String field, Map input}) {
		ValidationError error;
		for (final validation
		in validations.where((element) => element.field == field)) {
			error = validation.validate(input);
			if (error!=null) {
				return error;
			}
		}
		return error;
	}
}