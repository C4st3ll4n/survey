import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/presentation/protocols/protocols.dart';
import 'package:meta/meta.dart';
import 'package:survey/validation/protocols/field_validate.dart';

class FieldValidationSpy extends Mock implements FieldValidation {}

void main() {
  ValidationComposite sut;
  FieldValidation validation1;
  FieldValidation validation2;
  FieldValidation validation3;

  void mockValidation1(String error) {
    when(validation1.validate(any)).thenReturn(error);
  }

  void mockValidation2(String error) {
    when(validation2.validate(any)).thenReturn(error);
  }

  void mockValidation3(String error) {
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
    mockValidation2('');

    final error = sut.validate(field: 'any_field', value: 'any_value');
    expect(error, null);
  });

  test("Should return the first error of the correct field", () {
    mockValidation1('error_1');
    mockValidation2('error_2');
    mockValidation3('error_3');

    final error = sut.validate(field: 'any_field', value: 'any_value');
    expect(error, 'error_2');
  });
}

class ValidationComposite implements Validation {
  ValidationComposite(this.validations);

  final List<FieldValidation> validations;

  @override
  String validate({String field, String value}) {
    String error;
    for (final validation
        in validations.where((element) => element.field == field)) {
      error = validation.validate(value);
      if (error?.isNotEmpty == true) {
        return error;
      }
    }
    return error;
  }
}
