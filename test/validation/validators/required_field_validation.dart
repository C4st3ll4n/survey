import 'package:flutter_test/flutter_test.dart';

void main(){
	
	RequiredFieldValidation sut;
	
	setUp((){
		sut = RequiredFieldValidation('any_field');
	});
	
	test("Should return null if value is not empty",(){
		expect(sut.validate('any_value'), null);
	});
	test("Should return error if value is empty",(){
		expect(sut.validate(''), "Campo obrigatório.");
	});
}

class RequiredFieldValidation implements FieldValidation{
 
	RequiredFieldValidation(this.field);
 
	final String field;

  @override
  String validate(String value) {
	  return value.isEmpty? "Campo obrigatório.":null;
  }

}

abstract class FieldValidation {
	String get field;
	String validate(String value);
}