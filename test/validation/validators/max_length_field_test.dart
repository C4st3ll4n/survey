import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:survey/presentation/protocols/protocols.dart';
import 'package:survey/validation/validators/min_length_field_validation.dart';
import 'package:survey/validation/validators/validators.dart';

void main(){
	
	MaxLengthFieldValidation sut;
	
	setUp((){
		sut = MaxLengthFieldValidation(field: "any", maxLength: 12);
		
	});
	
	test("Should return error if value is empty",(){
		final error = sut.validate("");
		expect(error, ValidationError.invalidField);
	});
	
	test("Should return error if value is null",(){
		final error = sut.validate(null);
		expect(error, ValidationError.invalidField);
	});
	
	test("Should return error if value is less than max size",(){
		final error = sut.validate(faker.randomGenerator.string(4, min: 1));
		expect(error, null);
	});
	
	test("Should return error if value is equal than max size",(){
		final error = sut.validate(faker.randomGenerator.string(12, min: 12));
		expect(error, null);
	});
	
	test("Should return error if value is more than max size",(){
		final error = sut.validate(faker.randomGenerator.string(20, min: 13));
		expect(error, ValidationError.invalidField);
	});
}