import 'package:flutter/material.dart';
import '../../../../ui/pages/splash/splash.dart';
import 'splash_presenter_factory.dart';

Widget makeSplashPage() => SplashPage(presenter: makeGetXSplashPresenter());
