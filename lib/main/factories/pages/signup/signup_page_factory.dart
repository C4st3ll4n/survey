import 'package:flutter/material.dart';
import 'package:survey/main/factories/pages/signup/signup_presenter_factory.dart';
import '../../../../ui/pages/pages.dart';

Widget makeSignUpPage() => SignUpPage(presenter: makeGetXSignupPresenter());
