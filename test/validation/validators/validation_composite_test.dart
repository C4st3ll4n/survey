import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/presentation/protocols/protocols.dart';
import 'package:meta/meta.dart';
import 'package:survey/validation/protocols/field_validate.dart';

class FieldValidationSpy extends Mock implements FieldValidation{}

void main(){
	ValidationComposite sut;
	
	setUp((){
	
	});
	test("Should return null if all validators return null or empty",(){
		final validation1 = FieldValidationSpy();
		final validation2 = FieldValidationSpy();
		
		when(validation1.field).thenReturn("any_field");
		when(validation1.validate(any)).thenReturn(null);
		when(validation2.field).thenReturn(null);
		when(validation2.validate(any)).thenReturn('');
		
		sut = ValidationComposite([validation1, validation2]);
		final error = sut.validate(field: 'any_field',value: 'any_value');
		
		expect(error, null);
		
	});
}

class ValidationComposite implements Validation {
  ValidationComposite(this.validations);
  
	final List<FieldValidation> validations;

  @override
  String validate({String field, String value}) {
  	return null;
  }
}