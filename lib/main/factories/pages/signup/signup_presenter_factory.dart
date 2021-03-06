import '../../factories.dart';
import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';

/*

LoginPresenter makeStreamLoginPresenter() => StreamLoginPresenter(
      validation: makeLoginValidation(), authentication: makeRemoteAuthentication(), saveCurrentAccount: makeLocalSaveCurrentAccount());
*/

SignUpPresenter makeGetXSignupPresenter() => GetXSignUpPresenter(
		validation: makeSignupValidation(),
		saveCurrentAccount: makeLocalSaveCurrentAccount(),
		addAccount: makeAddAccount());