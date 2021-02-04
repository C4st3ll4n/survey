import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import '../protocols/protocols.dart';
import '../../presentation/protocols/protocols.dart';

class MinLengthFieldValidation extends Equatable implements FieldValidation {
	MinLengthFieldValidation({ @required this.field, @required this.minLength});
	
	final String field;
	final int minLength;
	
	@override
	List<Object> get props => [field];
	
	@override
	ValidationError validate(Map input) {
		if (input[field] != null && input[field].trim().isNotEmpty && input[field].length >= minLength) return null;
		return ValidationError.invalidField;
	}
}
