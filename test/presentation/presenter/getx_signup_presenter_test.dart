import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:survey/domain/entities/account_entity.dart';
import 'package:survey/domain/helpers/domain_error.dart';
import 'package:survey/domain/usecases/authentication.dart';
import 'package:survey/domain/usecases/usecases.dart';
import 'package:survey/presentation/presenters/getx_signup_presenter.dart';

import 'package:survey/presentation/presenters/presenters.dart';
import 'package:survey/presentation/protocols/protocols.dart';
import 'package:survey/ui/helpers/errors/errors.dart';
import 'package:survey/ui/pages/login/login_presenter.dart';

class ValidationSpy extends Mock implements Validation {}

class AddAccountSpy extends Mock implements AddAccount {}

class SaveCurrentAccountSpy extends Mock implements SaveCurrentAccount {}

void main() {
  String name;
  String email;
  String token;
  String password;
  String passwordConfirmation;
  Validation validation;
  AddAccount addAccount;
  GetXSignUpPresenter sut;
  SaveCurrentAccount saveCurrentAccount;

  PostExpectation mockValidationCall(String field) => when(
        validation.validate(
          field: field != null ? field : anyNamed("field"),
          value: anyNamed("value"),
        ),
      );

  void mockValidation({String field, ValidationError value}) =>
      mockValidationCall(field).thenReturn(value);

  PostExpectation mockAuthenticationCall() => when(
        addAccount.register(
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
      name = faker.person.name();
      saveCurrentAccount = SaveCurrentAccountSpy();
      validation = ValidationSpy();
      addAccount = AddAccountSpy();

      sut = GetXSignUpPresenter(
          validation: validation,
          addAccount: addAccount,
          saveCurrentAccount: saveCurrentAccount);

      email = faker.internet.email();
      password = faker.internet.password();
      passwordConfirmation = password;

      mockValidation();
      mockAuthentication();
    },
  );

  test(
    "Should call saveCurrentAccount with correct value",
    () async {
      sut.validateEmail(email);
      sut.validatePassword(password);

      await sut.signup();

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
          [!false, !true],
        ),
      );

      sut.mainErrorStream.listen(
        expectAsync1(
          (error) => expect(error, UIError.unexpected),
        ),
      );

      await sut.signup();
    },
  );

  test(
    "Should call validation with correct e-mail",
    () {
      sut.validateEmail(email);

      verify(validation.validate(field: "email", value: email)).called(1);
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
      sut.validatePassword(password);

      verify(validation.validate(field: "password", value: password)).called(1);
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

  /* NAME TESTS */

  test(
    "Should call validation with correct name",
    () {
      sut.validateName(name);

      verify(validation.validate(field: "name", value: name)).called(1);
    },
  );

  test(
    "Should emit invalidFieldError if name validation fails",
    () {
      //mockValidationCall().thenReturn("error");
      mockValidation(value: ValidationError.invalidField);

      sut.nameErrorStream.listen(
        expectAsync1(
          (error) => expect(error, UIError.invalidField),
        ),
      );

      sut.isFormValidStream.listen(
        expectAsync1(
          (isValid) => expect(isValid, false),
        ),
      );

      sut.validateName(name);
      sut.validateName(name);
    },
  );

  test(
    "Should emit invalidFieldError if name is empty",
    () {
      //mockValidationCall().thenReturn("error");
      mockValidation(value: ValidationError.requiredField);

      sut.nameErrorStream.listen(
        expectAsync1(
          (error) => expect(error, UIError.requiredField),
        ),
      );

      sut.isFormValidStream.listen(
        expectAsync1(
          (isValid) => expect(isValid, false),
        ),
      );

      sut.validateName(name);
      sut.validateName(name);
    },
  );

  test(
    "Should emit null if name validation succeeds",
    () {
      sut.nameErrorStream.listen(
        expectAsync1(
          (error) => expect(error, null),
        ),
      );

      sut.isFormValidStream.listen(
        expectAsync1(
          (isValid) => expect(isValid, false),
        ),
      );

      sut.validateName(name);
      sut.validateName(name);
    },
  );

// PASSWORD CONFIRMATION TEST

  test(
    "Should call validation with correct password confirmation",
    () {
      sut.validatePasswordConfirmation(password);

      verify(validation.validate(
              field: "passwordConfirmation", value: passwordConfirmation))
          .called(1);
    },
  );

  test(
    "Should emit password confirmation error if validation fails",
    () {
      //mockValidationCall().thenReturn("error");
      mockValidation(value: ValidationError.requiredField);

      sut.passwordConfirmationErrorStream.listen(
        expectAsync1(
          (error) => expect(error, UIError.requiredField),
        ),
      );

      sut.isFormValidStream.listen(
        expectAsync1(
          (isValid) => expect(isValid, false),
        ),
      );

      sut.validatePasswordConfirmation(passwordConfirmation);
      sut.validatePasswordConfirmation(passwordConfirmation);
    },
  );

  test(
    "Should emit null if password confirmation validation succeeds",
    () {
      sut.passwordConfirmationErrorStream.listen(
        expectAsync1(
          (error) => expect(error, null),
        ),
      );

      sut.isFormValidStream.listen(
        expectAsync1(
          (isValid) => expect(isValid, false),
        ),
      );

      sut.validatePasswordConfirmation(passwordConfirmation);
      sut.validatePasswordConfirmation(passwordConfirmation);
    },
  );

  test("Should enable form button if all field are valid", () async {
    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validateEmail(email);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
    await Future.delayed(Duration.zero);
    sut.validateName(name);
    await Future.delayed(Duration.zero);
    sut.validatePasswordConfirmation(passwordConfirmation);
  });

  test(
    "Should call addAccount with correct values",
    () async {
      sut.validateEmail(email);
      sut.validatePassword(password);
      sut.validateName(name);
      sut.validatePasswordConfirmation(passwordConfirmation);

      await sut.signup();

      verify(
        addAccount.register(
          RegisterParams(
              email: email,
              password: password,
              name: name,
              passwordConfirmation: passwordConfirmation),
        ),
      ).called(1);
    },
  );

  test(
    "Should emit correct event on AddAccount email in use error",
    () async {
      mockAuthenticationError(DomainError.emailInUse);

      sut.validateEmail(email);
      sut.validatePassword(password);
      sut.validateName(name);
      sut.validatePasswordConfirmation(passwordConfirmation);

      expectLater(
        sut.isLoadingStream,
        emitsInOrder(
          [!false, !true],
        ),
      );

      sut.mainErrorStream.listen(
        expectAsync1(
          (error) => expect(error, UIError.emailInUse),
        ),
      );

      await sut.signup();
    },
  );

  test(
    "Should emit correct event on AddAccount unexpected error",
    () async {
      mockAuthenticationError(DomainError.unexpected);

      sut.validateEmail(email);
      sut.validatePassword(password);
      sut.validateName(name);
      sut.validatePasswordConfirmation(passwordConfirmation);

      expectLater(
        sut.isLoadingStream,
        emitsInOrder(
          [!false, !true],
        ),
      );

      sut.mainErrorStream.listen(
        expectAsync1(
          (error) => expect(error, UIError.unexpected),
        ),
      );

      await sut.signup();
    },
  );

  test(
    "Should change page on success",
    () async {
      sut.validateEmail(email);
      sut.validatePassword(password);
      sut.validateName(name);
      sut.validatePasswordConfirmation(passwordConfirmation);

      sut.navigateToStream.listen(
        expectAsync1(
          (page) => expect(page, "/surveys"),
        ),
      );

      await sut.signup();
    },
  );

  test(
    "Should call saveCurrentAccount with correct value",
    () async {
      sut.validateEmail(email);
      sut.validatePassword(password);
      sut.validateName(name);
      sut.validatePasswordConfirmation(passwordConfirmation);

      await sut.signup();

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
      sut.validateName(name);
      sut.validatePasswordConfirmation(passwordConfirmation);

      expectLater(
        sut.isLoadingStream,
        emitsInOrder(
          [!false, !true],
        ),
      );

      sut.mainErrorStream.listen(
        expectAsync1(
          (error) => expect(error, UIError.unexpected),
        ),
      );

      await sut.signup();
    },
  );
}
