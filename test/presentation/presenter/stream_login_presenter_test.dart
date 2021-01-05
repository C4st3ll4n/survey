import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/ui/pages/login/login_presenter.dart';
import 'package:meta/meta.dart';


class LoginState{
  String emailError;
}

class StreamLoginPresenter implements LoginPresenter {
  final Validation validation;
  var _state = LoginState();
  final _controller = StreamController<LoginState>.broadcast();
  Stream<String> get emailErrorController => _controller.stream.map((state) => state.emailError);
  
  StreamLoginPresenter({this.validation});

  @override
  Future<void> auth() {
    // TODO: implement auth
    throw UnimplementedError();
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  // TODO: implement emailErrorStream
  Stream<String> get emailErrorStream => emailErrorController;

  @override
  // TODO: implement isFormValidStream
  Stream<bool> get isFormValidStream => throw UnimplementedError();

  @override
  // TODO: implement isLoadingStream
  Stream<bool> get isLoadingStream => throw UnimplementedError();

  @override
  // TODO: implement mainErrorStream
  Stream<String> get mainErrorStream => throw UnimplementedError();

  @override
  // TODO: implement passwordErrorStream
  Stream<String> get passwordErrorStream => throw UnimplementedError();

  @override
  void validateEmail(String email) {
    _state.emailError = validation.validate(field: "email", value: email);
    _controller.add(_state);
  }

  @override
  void validatePassword(String password) {
    // TODO: implement validatePassword
  }
}

class ValidationSpy extends Mock implements Validation {}

abstract class Validation {
  String validate({@required String field, @required String value});
}

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
