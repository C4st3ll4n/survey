import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/presentation/protocols/protocols.dart';
import 'package:survey/validation/protocols/protocols.dart';
import 'package:survey/validation/validators/validators.dart';

class FieldValidationSpy extends Mock implements FieldValidation {}

void main() {
  ValidationComposite sut;
  FieldValidation validation1;
  FieldValidation validation2;
  FieldValidation validation3;

  void mockValidation1(ValidationError error) {
    when(validation1.validate(any)).thenReturn(error);
  }

  void mockValidation2(ValidationError error) {
    when(validation2.validate(any)).thenReturn(error);
  }

  void mockValidation3(ValidationError error) {
    when(validation3.validate(any)).thenReturn(error);
  }

  setUp(() {
    validation1 = FieldValidationSpy();
    when(validation1.field).thenReturn("other_field");
    mockValidation1(null);

    validation2 = FieldValidationSpy();
    when(validation2.field).thenReturn("any_field");
    mockValidation2(null);

    validation3 = FieldValidationSpy();
    when(validation3.field).thenReturn("any_field");
    mockValidation3(null);

    sut = ValidationComposite([validation1, validation2, validation3]);
  });

  test("Should return null if all validators return null or empty", () {
    mockValidation2(null);

    final error = sut.validate(field: 'any_field', input: {});
    expect(error, null);
  });

  test("Should return the first error of the correct field", () {
    mockValidation1(ValidationError.requiredField);
    mockValidation2(ValidationError.invalidField);
    mockValidation3(ValidationError.invalidField);

    final error = sut.validate(field: 'any_field', input: {});
    expect(error, ValidationError.invalidField);
  });
}

