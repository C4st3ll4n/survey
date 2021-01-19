
import 'package:equatable/equatable.dart';
import 'package:survey/presentation/protocols/protocols.dart';

import '../protocols/protocols.dart';

class RequiredFieldValidation extends Equatable implements FieldValidation{
	
	RequiredFieldValidation(this.field);
	
	final String field;
	
	@override
	ValidationError validate(String value) {
		return value?.isNotEmpty==true? null:ValidationError.requiredField;
	}

  @override
  // TODO: implement props
  List<Object> get props => [field];
	
}
