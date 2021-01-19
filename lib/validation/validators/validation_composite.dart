import '../../presentation/protocols/protocols.dart';
import '../protocols/protocols.dart';

class ValidationComposite implements Validation {
	ValidationComposite(this.validations);
	
	final List<FieldValidation> validations;
	
	@override
	ValidationError validate({String field, String value}) {
		ValidationError error;
		for (final validation
		in validations.where((element) => element.field == field)) {
			error = validation.validate(value);
			if (error!=null) {
				return error;
			}
		}
		return error;
	}
}