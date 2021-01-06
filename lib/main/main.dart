import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import '../ui/components/components.dart';

import 'factories/factories.dart';

void main(){
	runApp(App());
}


class App extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
		
		return GetMaterialApp(
			debugShowCheckedModeBanner: false,
			title: "Survey",
			initialRoute: "/login",
			theme: appTheme(),
			getPages: [
				GetPage(name: "/login", page:makeLoginPage),
			],
		);
	}
}