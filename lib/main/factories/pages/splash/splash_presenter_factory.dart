import '../../factories.dart';
import '../../../../ui/pages/splash/splash.dart';
import '../../../../presentation/presenters/presenters.dart';

SplashPresenter makeGetXSplashPresenter() =>
    GetXSplashPresenter(makeLocalLoadCurrentAccount());
