import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:survey/presentation/protocols/protocols.dart';
import 'package:survey/validation/validators/validators.dart';

void main(){
	EmailValidation sut;
	
	setUp((){
		sut = EmailValidation('any_field');
	});
	
	test("Should return null on invalid case",(){
		expect(sut.validate({}), null);
	});
	
	test("Should return null if email is empty",(){
		final _input = {"any_field":""};
		expect(sut.validate(_input), null);
	});
	
	test("Should return null if email is null",(){
		expect(sut.validate({"any_field":null}), null);
	});
	
	test("Should return null if email is valid",(){
		expect(sut.validate({"any_field":faker.internet.email()}), null);
	});
	
	test("Should return error if email is invalid",(){
		expect(sut.validate({"any_field":"p13dr0h"}), ValidationError.invalidField);
	});
}
