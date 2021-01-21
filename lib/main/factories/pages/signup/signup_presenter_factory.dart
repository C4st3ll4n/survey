import 'package:survey/presentation/presenters/presenters.dart';
import 'package:survey/ui/pages/pages.dart';

import '../../factories.dart';
/*

LoginPresenter makeStreamLoginPresenter() => StreamLoginPresenter(
      validation: makeLoginValidation(), authentication: makeRemoteAuthentication(), saveCurrentAccount: makeLocalSaveCurrentAccount());
*/

SignUpPresenter makeGetXSignupPresenter() => GetXSignUpPresenter(
		validation: makeLoginValidation(),
		saveCurrentAccount: makeLocalSaveCurrentAccount(), addAccount: makeAddAccount());