import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:survey/presentation/protocols/protocols.dart';
import 'package:survey/validation/validators/validators.dart';

void main() {
  MinLengthFieldValidation sut;

  setUp(() {
    sut = MinLengthFieldValidation(field: "any", minLength: 6);
  });

  test("Should return error if value is empty", () {
    final error = sut.validate({"any": ""});
    expect(error, ValidationError.invalidField);
  });

  test("Should return error if value is null", () {
    final error = sut.validate({"any": null});
    expect(error, ValidationError.invalidField);
  });

  test("Should return error if value is less than min size", () {
    final error = sut.validate(
      {
        "any": faker.randomGenerator.string(4, min: 1),
      },
    );
    expect(error, ValidationError.invalidField);
  });

  test("Should return error if value is equal than min size", () {
    final error = sut.validate(
      {
        "any": faker.randomGenerator.string(6, min: 6),
      },
    );
    expect(error, null);
  });

  test("Should return error if value is more than min size", () {
    final error = sut.validate(
      {
        "any": faker.randomGenerator.string(10, min: 7),
      },
    );
    expect(error, null);
  });
}
