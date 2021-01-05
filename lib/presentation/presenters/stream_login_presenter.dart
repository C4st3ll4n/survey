import 'dart:async';

import 'package:meta/meta.dart';

import '../protocols/protocols.dart';

import '../../domain/usecases/authentication.dart';
import '../../ui/pages/login/login_presenter.dart';

class StreamLoginPresenter implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;
  var _state = LoginState();
  final _controller = StreamController<LoginState>.broadcast();

  StreamLoginPresenter(
      {@required this.validation, @required this.authentication});

  @override
  Future<void> auth() async {
    _state.isLoading = true;
    _update();
    
    await authentication.auth(
      AuthenticationParams(email: _state.email, secret: _state.password),
    );
    
    _state.isLoading = false;
    _update();
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  // TODO: implement emailErrorStream
  Stream<String> get emailErrorStream =>
      _controller.stream.map((state) => state.emailError).distinct();

  @override
  // TODO: implement isFormValidStream
  Stream<bool> get isFormValidStream =>
      _controller.stream.map((state) => state.isFormValid).distinct();

  @override
  // TODO: implement isLoadingStream
  Stream<bool> get isLoadingStream =>
      _controller.stream.map((state) => state.isLoading).distinct();

  @override
  // TODO: implement mainErrorStream
  Stream<String> get mainErrorStream => throw UnimplementedError();

  @override
  // TODO: implement passwordErrorStream
  Stream<String> get passwordErrorStream =>
      _controller.stream.map((state) => state.passwordError).distinct();

  @override
  void validateEmail(String email) {
    _state.email = email;
    _state.emailError = validation.validate(field: "email", value: email);
    _update();
  }

  @override
  void validatePassword(String password) {
    _state.password = password;
    _state.passwordError =
        validation.validate(field: "password", value: password);
    _update();
  }

  void _update() => _controller.add(_state);
}

class LoginState {
  String email, password;
  String emailError;
  String passwordError;
  bool isLoading = false;
  bool get isFormValid =>
      emailError == null &&
      passwordError == null &&
      email != null &&
      password != null;
}
