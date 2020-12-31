import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/ui/pages/login/login_presenter.dart';
import 'package:meta/meta.dart';

class StreamLoginPresenter implements LoginPresenter {
  
  final Validation validation;

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
  Stream<String> get emailErrorStream => throw UnimplementedError();

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
    validation.validate(field: "email", value: email);
  }

  @override
  void validatePassword(String password) {
    // TODO: implement validatePassword
  }
}

class ValidationSpy extends Mock implements Validation{}

abstract class Validation{
  void validate({@required String field, @required String value});
}

void main() {
  String email;
  Validation validation;
  StreamLoginPresenter sut;
  
  setUp((){
     validation =  ValidationSpy();
     sut = StreamLoginPresenter(validation: validation);
     email = faker.internet.email();
  
  });
  
  test(
    "Should call validation with correct e-mail",
    () {
     
      sut.validateEmail(email);
      
      verify(validation.validate(field:"email", value:email)).called(1);
    },
  );

  test(
    "Should call validation with correct password",
        () {},
  );
}
