
import '../protocols/protocols.dart';

class RequiredFieldValidation implements FieldValidation{
	
	RequiredFieldValidation(this.field);
	
	final String field;
	
	@override
	String validate(String value) {
		return value?.isNotEmpty==true? null:"Campo obrigatório.";
	}
	
}
