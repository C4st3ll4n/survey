import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/presentation/presenters/presenters.dart';
import 'package:survey/presentation/protocols/protocols.dart';

class ValidationSpy extends Mock implements Validation {}

void main() {
  String email;
  String password;
  Validation validation;
  StreamLoginPresenter sut;

  PostExpectation mockValidationCall(String field) => when(
        validation.validate(
          field: field != null ? field : anyNamed("field"),
          value: anyNamed("value"),
        ),
      );

  void mockValidation({String field, String value}) =>
      mockValidationCall(field).thenReturn(value);

  setUp(() {
    validation = ValidationSpy();
    sut = StreamLoginPresenter(validation: validation);
    email = faker.internet.email();
    password = faker.internet.password();
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
      mockValidation(value: "error");

      sut.emailErrorStream.listen(
        expectAsync1(
          (error) => expect(error, "error"),
        ),
      );


      sut.isFormValidStream.listen(
        expectAsync1(
              (isValid) => expect(isValid, false),
        ),
      );

      sut.validateEmail(email);
      sut.validateEmail(email);
    },
  );


  test(
    "Should emit null if validation succeeds",
        () {
      sut.emailErrorStream.listen(
        expectAsync1(
              (error) => expect(error, null),
        ),
      );
    
    
      sut.isFormValidStream.listen(
        expectAsync1(
              (isValid) => expect(isValid, false),
        ),
      );
    
      sut.validateEmail(email);
      sut.validateEmail(email);
    },
  );
  
  /* PASSWORD VALIDATION */


  test(
    "Should call validation with correct password",
        () {
      sut.validatePassword(password);
    
      verify(validation.validate(field: "password", value: password)).called(1);
    },
  );

  test(
    "Should emit password error if validation fails",
        () {
      //mockValidationCall().thenReturn("error");
      mockValidation(value: "error");
    
      sut.passwordErrorStream.listen(
        expectAsync1(
              (error) => expect(error, "error"),
        ),
      );
    
    
      sut.isFormValidStream.listen(
        expectAsync1(
              (isValid) => expect(isValid, false),
        ),
      );
    
      sut.validatePassword(password);
      sut.validatePassword(password);
    },
  );


  test(
    "Should emit null if password validation succeeds",
        () {
      sut.passwordErrorStream.listen(
        expectAsync1(
              (error) => expect(error, null),
        ),
      );
    
    
      sut.isFormValidStream.listen(
        expectAsync1(
              (isValid) => expect(isValid, false),
        ),
      );

      sut.validatePassword(password);
      sut.validatePassword(password);
    },
  );
  
}
