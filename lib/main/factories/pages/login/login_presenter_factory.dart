import '../../factories.dart';
import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/login/login_presenter.dart';
/*

LoginPresenter makeStreamLoginPresenter() => StreamLoginPresenter(
      validation: makeLoginValidation(), authentication: makeRemoteAuthentication(), saveCurrentAccount: makeLocalSaveCurrentAccount());
*/

LoginPresenter makeGetXLoginPresenter() => GetXLoginPresenter(
		validation: makeLoginValidation(), authentication: makeRemoteAuthentication(), saveCurrentAccount: makeLocalSaveCurrentAccount());