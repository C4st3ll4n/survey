import 'package:flutter/material.dart';
import '../../factories.dart';
import '../../../../ui/pages/pages.dart';

Widget makeSignUpPage() => SignUpPage(presenter: makeGetXSignupPresenter());
