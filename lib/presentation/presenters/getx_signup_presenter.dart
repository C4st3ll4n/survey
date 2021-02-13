import 'package:get/get.dart';
import 'package:meta/meta.dart';
import '../mixins/mixins.dart';
import '../protocols/protocols.dart';
import '../../domain/entities/account_entity.dart';
import '../../domain/usecases/add_account.dart';
import '../../domain/usecases/save_current_account.dart';
import '../../ui/helpers/errors/errors.dart';
import '../../ui/pages/pages.dart';
import '../../domain/helpers/domain_error.dart';

class GetXSignUpPresenter extends GetxController with LoadingManager, NavigationManager, FormManager, UIErrorManager implements SignUpPresenter {
  final Validation validation;
  final AddAccount addAccount;
  final SaveCurrentAccount saveCurrentAccount;

  String _email;
  String _password;
  String _name;
  String _passwordConfirmation;

  var _emailError = Rx<UIError>();
  var _nameError = Rx<UIError>();
  var _passwordConfirmationError = Rx<UIError>();
  var _passwordError = Rx<UIError>();

  GetXSignUpPresenter(
      {@required this.validation,
      @required this.addAccount,
      @required this.saveCurrentAccount});

  @override
  Stream<UIError> get nameErrorStream => _nameError.stream.distinct();

  @override
  Stream<UIError> get passwordConfirmationErrorStream =>
      _passwordConfirmationError.stream.distinct();

  @override
  Stream<UIError> get emailErrorStream => _emailError.stream.distinct();

  @override
  Stream<bool> get isFormValidStream => validFormStream;

  @override
  Stream<bool> get isLoadingStream => loadingStream;

  @override
  Stream<UIError> get mainErrorStream => uiErrorStream;

  @override
  Stream<UIError> get passwordErrorStream => _passwordError.stream.distinct();

  @override
  Stream<String> get navigateToStream => navigationStream;

  @override
  Future<void> signup() async {
    uiError = null;
    isLoading = true;

    try {
      final AccountEntity account = await addAccount.register(
        RegisterParams(
            email: _email,
            password: _password,
            name: _name,
            passwordConfirmation: _passwordConfirmation),
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
    } catch (e, stck){
    }
  }

  /// Unnecesary: GetX automatcally disposes
  @override
  void dispose() {}

  UIError _validateField(String field) {
    final formData = {
      'email': _email,
      'password': _password,
      'name': _name,
      'passwordConfirmation': _passwordConfirmation
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
        return UIError.shortField;
        break;
      case ValidationError.tooLongField:
        return UIError.longField;
        break;
      case ValidationError.unmatchField:
        return UIError.unmatchField;
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
      _nameError.value == null &&
      _passwordConfirmationError.value == null &&
      _passwordError.value == null &&
      _email != null &&
      _name != null &&
      _passwordConfirmation != null &&
      _password != null;

  @override
  void validateName(String name) {
    _name = name;
    _nameError.value = _validateField("name");
    validateForm();
  }

  @override
  void validatePasswordConfirmation(String password) {
    _passwordConfirmation = password;
    _passwordConfirmationError.value = _validateField(
      "passwordConfirmation",
    );
    validateForm();
  }

  @override
  void goToLogin() {
    goTo = "/login";
  }
}
