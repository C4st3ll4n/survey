import 'package:get/get.dart';
import 'package:meta/meta.dart';
import '../mixins/mixins.dart';
import '../protocols/protocols.dart';
import '../../domain/usecases/usecases.dart';
import '../../domain/entities/entities.dart';
import '../../ui/helpers/errors/errors.dart';
import '../../domain/helpers/domain_error.dart';
import '../../ui/pages/login/login_presenter.dart';

class GetXLoginPresenter extends GetxController
    with LoadingManager, NavigationManager, FormManager, UIErrorManager
    implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;
  final SaveCurrentAccount saveCurrentAccount;

  String _email;
  String _password;

  var _emailError = Rx<UIError>();
  var _passwordError = Rx<UIError>();

  GetXLoginPresenter(
      {@required this.validation,
      @required this.authentication,
      @required this.saveCurrentAccount});

  @override
  Stream<UIError> get emailErrorStream => _emailError.stream.distinct();

  @override
  Stream<bool> get isFormValidStream => validFormStream;

  @override
  Stream<UIError> get mainErrorStream => uiErrorStream;

  @override
  Stream<UIError> get passwordErrorStream => _passwordError.stream.distinct();
  
  @override
  Stream<bool> get isLoadingStream => loadingStream;

  @override
  Stream<String> get navigateToStream => navigationStream;

  @override
  Future<void> auth() async {
    isLoading = true;
    uiError = null;
    try {
      final AccountEntity account = await authentication.auth(
        AuthenticationParams(email: _email, secret: _password),
      );
      await saveCurrentAccount.save(account);

      goTo = "/surveys";
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.unexpected:
          uiError = UIError.unexpected;
          break;
        case DomainError.invalidCredentials:
          uiError = UIError.invalidCredentials;
          break;
        case DomainError.emailInUse:
          uiError = UIError.emailInUse;
          break;
        case DomainError.accessDenied:
          uiError = UIError.unexpected;
          break;
      }
      isLoading = false;
    }
  }

  /// Unnecesary: GetX automatcally disposes
  @override
  void dispose() {}

  UIError _validateField(String field) {
    final formData = {
      'email': _email,
      'password': _password,
    };

    final error = validation.validate(field: field, input: formData);
    switch (error) {
      case ValidationError.requiredField:
        return UIError.requiredField;
        break;
      case ValidationError.invalidField:
        return UIError.invalidField;
        break;
      case ValidationError.tooShortField:
        return null;
        break;
      case ValidationError.tooLongField:
        return null;
        break;
      default:
        return null;
    }
  }

  @override
  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validateField("email");
    validateForm();
  }

  @override
  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validateField("password");
    validateForm();
  }

  void validateForm() => formStatus = _emailError.value == null &&
      _passwordError.value == null &&
      _email != null &&
      _password != null;

  @override
  void goToSignup() => goTo = "/signUp";
}
