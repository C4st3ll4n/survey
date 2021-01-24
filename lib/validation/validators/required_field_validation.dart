
import 'package:equatable/equatable.dart';
import '../../presentation/protocols/protocols.dart';

import '../protocols/protocols.dart';

class RequiredFieldValidation extends Equatable implements FieldValidation{
	
	RequiredFieldValidation(this.field);
	
	final String field;
	
	@override
	ValidationError validate(Map input) {
		return input[field]?.isNotEmpty==true? null:ValidationError.requiredField;
	}

  @override
  // TODO: implement props
  List<Object> get props => [field];
	
}
