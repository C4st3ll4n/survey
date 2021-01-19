import 'package:flutter/material.dart';
import 'package:survey/ui/pages/splash/splash.dart';
import 'splash_presenter_factory.dart';

Widget makeSplashPage() => SplashPage(presenter: makeGetXSplashPresenter());
