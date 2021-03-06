import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/domain/entities/entities.dart';
import 'package:survey/domain/helpers/helpers.dart';
import 'package:survey/domain/usecases/usecases.dart';
import 'package:survey/presentation/presenters/presenters.dart';
import 'package:survey/presentation/protocols/protocols.dart';
import 'package:survey/ui/helpers/helpers.dart';

class ValidationSpy extends Mock implements Validation {}

class AuthenticationSpy extends Mock implements Authentication {}

class SaveCurrentAccountSpy extends Mock implements SaveCurrentAccount {}

void main() {
  String email;
  String token;
  String password;
  Validation validation;
  Authentication authentication;
  GetXLoginPresenter sut;
  SaveCurrentAccount saveCurrentAccount;

  PostExpectation mockValidationCall(String field) => when(
        validation.validate(
          field: field != null ? field : anyNamed("field"),
          input: anyNamed("input"),
        ),
      );

  void mockValidation({String field, ValidationError value}) =>
      mockValidationCall(field).thenReturn(value);

  PostExpectation mockAuthenticationCall() => when(
        authentication.auth(
          any,
        ),
      );

  void mockAuthentication() =>
      mockAuthenticationCall().thenAnswer((_) async => AccountEntity(token));

  void mockAuthenticationError(DomainError error) =>
      mockAuthenticationCall().thenThrow(error);

  void mockSaveCurrentAccountError(DomainError error) =>
      mockAuthenticationCall().thenThrow(error ?? DomainError.unexpected);

  setUp(
    () {
      token = faker.guid.guid();
      saveCurrentAccount = SaveCurrentAccountSpy();
      validation = ValidationSpy();
      authentication = AuthenticationSpy();

      sut = GetXLoginPresenter(
          validation: validation,
          authentication: authentication,
          saveCurrentAccount: saveCurrentAccount);

      email = faker.internet.email();
      password = faker.internet.password();

      mockValidation();
      mockAuthentication();
    },
  );

  test(
    "Should call validation with correct e-mail",
    () {
      final _formData = {"password":null, "email":email};
  
      sut.validateEmail(email);

      verify(validation.validate(field: "email", input: _formData)).called(1);
    },
  );

  test(
    "Should call saveCurrentAccount with correct value",
    () async {
      sut.validateEmail(email);
      sut.validatePassword(password);

      await sut.auth();

      verify(
        saveCurrentAccount.save(
          AccountEntity(token),
        ),
      ).called(1);
    },
  );

  test(
    "Should emit correct unexpected error if saveCurrentAccount fails",
    () async {
      mockSaveCurrentAccountError(DomainError.unexpected);

      sut.validateEmail(email);
      sut.validatePassword(password);

      expectLater(
        sut.isLoadingStream,
        emitsInOrder(
          [true, false],
        ),
      );
      
      expectLater(
        sut.mainErrorStream,
        emitsInOrder(
          [null, UIError.unexpected],
        ),
      );


      await sut.auth();
    },
  );

  test(
    "Should emit invalidFieldError if email validation fails",
    () {
      //mockValidationCall().thenReturn("error");
      mockValidation(value: ValidationError.invalidField);

      sut.emailErrorStream.listen(
        expectAsync1(
          (error) => expect(error, UIError.invalidField),
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
    "Should emit invalidFieldError if email is empty",
    () {
      //mockValidationCall().thenReturn("error");
      mockValidation(value: ValidationError.requiredField);

      sut.emailErrorStream.listen(
        expectAsync1(
          (error) => expect(error, UIError.requiredField),
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
      final _formData = {"password":password, "email":null};
      sut.validatePassword(password);
      verify(validation.validate(field:"password", input: _formData)).called(1);
    },
  );

  test(
    "Should emit password error if validation fails",
    () {
      //mockValidationCall().thenReturn("error");
      mockValidation(value: ValidationError.requiredField);

      sut.passwordErrorStream.listen(
        expectAsync1(
          (error) => expect(error, UIError.requiredField),
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

  /* FORM TESTS */

  test(
    "Should emit email error if validation fails",
    () {
      //mockValidationCall().thenReturn("error");
      mockValidation(value: ValidationError.invalidField, field: "email");

      sut.emailErrorStream.listen(
        expectAsync1(
          (error) => expect(error, UIError.invalidField),
        ),
      );

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

      sut.validateEmail(email);
      sut.validatePassword(password);
    },
  );

  test(
    "Should emit success if validation is okay",
    () async {
      sut.emailErrorStream.listen(
        expectAsync1(
          (error) => expect(error, null),
        ),
      );

      sut.passwordErrorStream.listen(
        expectAsync1(
          (error) => expect(error, null),
        ),
      );
      expectLater(
        sut.isFormValidStream,
        emitsInOrder(
          [false, true],
        ),
      );

      sut.validateEmail(email);
      await Future.delayed(Duration.zero);
      sut.validatePassword(password);
    },
  );

  test(
    "Should call authentication with correct values",
    () async {
      sut.validateEmail(email);
      sut.validatePassword(password);

      await sut.auth();

      verify(
        authentication.auth(
          AuthenticationParams(email: email, secret: password),
        ),
      ).called(1);
    },
  );
  test(
    "Should emit correct event on Authentication success",
    () async {
      sut.validateEmail(email);
      sut.validatePassword(password);

      expectLater(
        sut.isLoadingStream,
        emits(
          true,
        ),
      );

      expectLater(sut.mainErrorStream, emits(null));


      await sut.auth();
    },
  );

  test(
    "Should emit correct event on Authentication invalid credentials error",
    () async {
      mockAuthenticationError(DomainError.invalidCredentials);

      sut.validateEmail(email);
      sut.validatePassword(password);

      expectLater(
        sut.isLoadingStream,
        emitsInOrder(
          [!false, !true],
        ),
      );
      expectLater(
        sut.mainErrorStream,
        emitsInOrder(
          [null, UIError.invalidCredentials],
        ),
      );

      await sut.auth();
    },
  );

  test(
    "Should emit correct event on Authentication unexpected error",
    () async {
      mockAuthenticationError(DomainError.unexpected);

      sut.validateEmail(email);
      sut.validatePassword(password);

      expectLater(
        sut.isLoadingStream,
        emitsInOrder(
          [!false, !true],
        ),
      );
      expectLater(
        sut.mainErrorStream,
        emitsInOrder(
          [null, UIError.unexpected],
        ),
      );
      await sut.auth();
    },
  );

  test(
    "Should change page on success",
    () async {
      sut.validateEmail(email);
      sut.validatePassword(password);

      sut.navigateToStream.listen(
        expectAsync1(
          (page) => expect(page, "/surveys"),
        ),
      );

      await sut.auth();
    },
  );
  
  test("Should go to SingUp page on click", () async{
    sut.navigateToStream.listen((page) => expect(page, "/signUp"));
    sut.goToSignup();
  });
  
}
