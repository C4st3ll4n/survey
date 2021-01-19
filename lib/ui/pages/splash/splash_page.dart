
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import 'splash_presenter.dart';

class SplashPage extends StatelessWidget {
	const SplashPage({Key key, @required this.presenter}) : super(key: key);
	
	final SplashPresenter presenter;
	
	@override
	Widget build(BuildContext context) {
		presenter.checkAccount();
		return Scaffold(
			appBar: AppBar(
				title: Text("Surveys"),
				centerTitle: true,
			),
			body: Builder(
				builder: (BuildContext context) {
					presenter.navigateToStream.listen(
								(page) {
							if (page?.isNotEmpty == true) {
								Get.offAllNamed(page);
							}
						},
					);
					
					return Center(
						child: CircularProgressIndicator(),
					);
				},
			),
		);
	}
}