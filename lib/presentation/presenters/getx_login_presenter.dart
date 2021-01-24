import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:survey/domain/entities/account_entity.dart';
import 'package:survey/domain/usecases/save_current_account.dart';
import 'package:survey/ui/helpers/errors/errors.dart';

import '../protocols/protocols.dart';

import '../../domain/helpers/domain_error.dart';
import '../../domain/usecases/authentication.dart';

import '../../ui/pages/login/login_presenter.dart';

class GetXLoginPresenter extends GetxController implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;
  final SaveCurrentAccount saveCurrentAccount;
  
  String _email;
  String _password;

  var _emailError = Rx<UIError>();
  var _passwordError = Rx<UIError>();
  var _mainError = Rx<UIError>();
  var _navigateTo = RxString();

  var _isFormValid = false.obs;
  var _isLoading = false.obs;


  GetXLoginPresenter(
      {@required this.validation, @required this.authentication, @required this.saveCurrentAccount});

  @override
  Stream<UIError> get emailErrorStream => _emailError.stream.distinct();

  @override
  Stream<bool> get isFormValidStream => _isFormValid.stream.distinct();

  @override
  Stream<bool> get isLoadingStream => _isLoading.stream.distinct();

  @override
  Stream<UIError> get mainErrorStream => _mainError.stream.distinct();

  @override
  Stream<UIError> get passwordErrorStream => _passwordError.stream.distinct();

  @override
  Stream<String> get navigateToStream => _navigateTo.stream.distinct();

  @override
  Future<void> auth() async {
    _isLoading.value = true;
    _mainError.value = null;
      try {
      final AccountEntity account = await authentication.auth(
        AuthenticationParams(email: _email, secret: _password),
      );
      await saveCurrentAccount.save(account);
      
      _navigateTo.value = "/surveys";
      
    } on DomainError catch (error) {
        switch(error){
          case DomainError.unexpected:
            _mainError.value = UIError.unexpected;
            break;
          case DomainError.invalidCredentials:
            _mainError.value = UIError.invalidCredentials;
            break;
          case DomainError.emailInUse:
            _mainError.value = UIError.emailInUse;
            break;
        }
      _isLoading.value = false;
    }

  }

  /// Unnecesary: GetX automatcally disposes
  @override
  void dispose() {}

  UIError _validateField(String field){
    final formData = {
      'email': _email,
      'password': _password,
    };
    
    final error = validation.validate(field: field, input: formData);
    switch(error){
    
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
      default: return null;
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
    _passwordError.value =
        _validateField("password");
    validateForm();
  }

  void validateForm() =>
      _isFormValid.value =
              _emailError.value == null &&
              _passwordError.value == null &&
              _email != null &&
              _password != null;

  @override
  goToSignup() {
    _navigateTo.value = "/signUp";
  }



}
