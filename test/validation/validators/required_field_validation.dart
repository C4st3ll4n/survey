import 'package:flutter_test/flutter_test.dart';

void main(){
	
	RequiredFieldValidation sut;
	
	setUp((){
		sut = RequiredFieldValidation('any_field');
	});
	
	test("Should return null if value is not empty",(){
		final error = sut.validate('any_value');
		expect(error, null);
	});
}

class RequiredFieldValidation implements FieldValidation{
 
	RequiredFieldValidation(this.field);
 
	final String field;

  @override
  String validate(String value) {
	  return null;
  }

}

abstract class FieldValidation {
	String get field;
	String validate(String value);
}