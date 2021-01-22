import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import '../../presentation/protocols/protocols.dart';
import '../protocols/protocols.dart';

class MinLengthFieldValidation extends Equatable implements FieldValidation {
	MinLengthFieldValidation({ @required this.field, @required this.minLength});
	
	final String field;
	final int minLength;
	
	@override
	List<Object> get props => [field];
	
	@override
	ValidationError validate(String value) {
		if (value != null && value.trim().isNotEmpty && value.length >= minLength) return null;
		return ValidationError.invalidField;
	}
}
