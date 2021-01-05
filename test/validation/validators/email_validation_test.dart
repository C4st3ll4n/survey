import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/validation/protocols/field_validate.dart';

void main(){
	EmailValidation sut;
	
	setUp((){
		sut = EmailValidation('any_field');
	});
	
	test("Should return null if email is empty",(){
		expect(sut.validate(''), null);
	});
	
	test("Should return null if email is null",(){
		expect(sut.validate(null), null);
	});
}

class EmailValidation implements FieldValidation {
  EmailValidation(this.field);
  
  final String field;

  @override
  String validate(String value) {
    return null;
  }
}