import '../protocols/protocols.dart';

class EmailValidation implements FieldValidation {
	EmailValidation(this.field);
	
	final String field;
	
	@override
	String validate(String value) {
		final RegExp regExp = RegExp(r"^[\w+.]+@\w+\.\w{2,}(?:\.\w{2})?$/");
		final isValid = value?.isNotEmpty != true || regExp.hasMatch(value)? true:false;
		return !isValid?null:"Campo inválido.";
	}
}