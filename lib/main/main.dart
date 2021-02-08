import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'factories/factories.dart';
import '../ui/components/components.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Survey",
      initialRoute: "/survey_result/1",
      theme: appTheme(),
      getPages: [
        GetPage(name: "/", page: makeSplashPage, transition: Transition.fade),
        GetPage(
            name: "/login", page: makeLoginPage, transition: Transition.fadeIn),
        GetPage(
          name: "/signUp",
          page: makeSignUpPage,
        ),
        GetPage(
          name: "/surveys",
          transition: Transition.fadeIn,
          page: makeSurveysPage,
        ),GetPage(
          name: "/survey_result/:survey_id",
          page: makeSurveyResultPage,
        ),
      ],
    );
  }

  
}
