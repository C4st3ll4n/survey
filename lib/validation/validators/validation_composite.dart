import '../../presentation/protocols/protocols.dart';
import '../protocols/protocols.dart';

class ValidationComposite implements Validation {
	ValidationComposite(this.validations);
	
	final List<FieldValidation> validations;
	
	@override
	String validate({String field, String value}) {
		String error;
		for (final validation
		in validations.where((element) => element.field == field)) {
			error = validation.validate(value);
			if (error?.isNotEmpty == true) {
				return error;
			}
		}
		return error;
	}
}