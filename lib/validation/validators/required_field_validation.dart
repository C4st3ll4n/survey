
import 'package:equatable/equatable.dart';

import '../protocols/protocols.dart';

class RequiredFieldValidation extends Equatable implements FieldValidation{
	
	RequiredFieldValidation(this.field);
	
	final String field;
	
	@override
	String validate(String value) {
		return value?.isNotEmpty==true? null:"Campo obrigatório.";
	}

  @override
  // TODO: implement props
  List<Object> get props => [field];
	
}
