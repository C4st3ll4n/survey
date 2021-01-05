import 'package:faker/faker.dart';
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
	
	test("Should return null if email is valid",(){
		expect(sut.validate(faker.internet.email()), null);
	});
	
	test("Should return null if email is valid",(){
		expect(sut.validate("p13dr0h"), "Campo inválido.");
	});
}

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