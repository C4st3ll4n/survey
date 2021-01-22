import 'package:flutter_test/flutter_test.dart';
import 'package:survey/presentation/protocols/protocols.dart';
import 'package:survey/validation/validators/compare_field_validation.dart';
void main(){
	
	CompareFieldValidation sut;
	
	setUp((){
		sut = CompareFieldValidation(field:'any_field', valueToCompare:"any_value");
	});
	
	test("Should return error if value is not equal",(){
		expect(sut.validate('wrong_value'), ValidationError.invalidField);
	});
	
	test("Should return error if value is empty",(){
		expect(sut.validate(''), ValidationError.requiredField);
	});
	
	test("Should return error if value is null",(){
		expect(sut.validate(null),ValidationError.requiredField);
	});
}
