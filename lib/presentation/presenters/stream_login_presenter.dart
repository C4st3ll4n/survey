import 'dart:async';

import '../../ui/pages/login/login_presenter.dart';

import '../../presentation/protocols/validation.dart';

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

class LoginState{
	String emailError;
}
