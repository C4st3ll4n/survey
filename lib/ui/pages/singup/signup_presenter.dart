import 'package:survey/ui/helpers/errors/errors.dart';

abstract class SignUpPresenter {
  Stream<UIError> get emailErrorStream;
  
  Stream<UIError> get nameErrorStream;
  
  Stream<UIError> get passwordConfirmationErrorStream;

  Stream<UIError> get passwordErrorStream;
  
  Stream<UIError> get mainErrorStream;
  
  Stream<String> get navigateToStream;

  Stream<bool> get isFormValidStream;

  Stream<bool> get isLoadingStream;

  void validateEmail(String email);
  
  void validateName(String name);

  void validatePassword(String password);
  
  void validatePasswordConfirmation(String password);

  Future<void> auth();

  void dispose();
}
