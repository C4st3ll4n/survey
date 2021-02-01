import '../../../../ui/pages/splash/splash.dart';

import '../../../../presentation/presenters/presenters.dart';
import '../../factories.dart';

SplashPresenter makeGetXSplashPresenter() =>
    GetXSplashPresenter(makeLocalLoadCurrentAccount());
