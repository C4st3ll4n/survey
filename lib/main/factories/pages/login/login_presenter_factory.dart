import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/login/login_presenter.dart';
import '../../factories.dart';

LoginPresenter makeLoginPresenter() => StreamLoginPresenter(
      validation: makeLoginValidation(), authentication: makeRemoteAuthentication());
