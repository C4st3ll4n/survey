import 'package:flutter_test/flutter_test.dart';
import 'package:survey/presentation/protocols/protocols.dart';
import 'package:survey/validation/validators/compare_field_validation.dart';
void main(){
	
	CompareFieldValidation sut;
	
	setUp((){
		sut = CompareFieldValidation(field:'any_field', fieldToCompare:"other_field");
	});
	
	test("Should return error if value is not equal",(){
		final input = {'field':'any_value', 'other_field':"wrong_value"};
		expect(sut.validate(input), ValidationError.unmatchField);
	});
	
	test("Should return error if fields are the same",(){
		final input = {'field':'any_value', 'other_field':"any_value"};
		expect(sut.validate(input),null);
	});
	
	test("Should return null if field name are diferent",(){
		//final input = {'field':'any_value', 'other_field':"any_value"};
		expect(sut.validate({'field':'any_value',}),null);
		expect(sut.validate({ 'other_field':"any_value"}),null);
		expect(sut.validate({}),null);
	});
}
