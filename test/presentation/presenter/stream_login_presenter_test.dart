
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/presentation/presenters/presenters.dart';
import 'package:survey/presentation/protocols/protocols.dart';



class ValidationSpy extends Mock implements Validation {}


void main() {
  String email;
  Validation validation;
  StreamLoginPresenter sut;
  
  PostExpectation mockValidationCall(String field) => when(
    validation.validate(
      field: field != null ? field: anyNamed("field"),
      value: anyNamed("value"),
    ),
  );
  
  void mockValidation({String field, String value}) => mockValidationCall(field).thenReturn(value);

  setUp(() {
    validation = ValidationSpy();
    sut = StreamLoginPresenter(validation: validation);
    email = faker.internet.email();
    mockValidation();
  });

  test(
    "Should call validation with correct e-mail",
    () {
      sut.validateEmail(email);

      verify(validation.validate(field: "email", value: email)).called(1);
    },
  );

  test(
    "Should emit email error if validation fails",
    () {
      //mockValidationCall().thenReturn("error");
      mockValidation(value:"error");
      
      expectLater(sut.emailErrorStream, emits("error"),);
      
      sut.validateEmail(email);
      
    },
  );
}
