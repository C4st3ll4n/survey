import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import '../../mixins/mixins.dart';
import 'splash_presenter.dart';

class SplashPage extends StatelessWidget with NavigationManager{
	const SplashPage({Key key, @required this.presenter}) : super(key: key);
	
	final SplashPresenter presenter;
	
	@override
	Widget build(BuildContext context) {
		presenter.checkAccount(durationInSeconds: 3);
		return Scaffold(
			appBar: AppBar(
				title: Text("Surveys"),
				centerTitle: true,
			),
			body: Builder(
				builder: (BuildContext contexto) {
					handleNavigation(stream: presenter.navigateToStream, clear: true);
					
					return Center(
						child: CircularProgressIndicator(),
					);
				},
			),
		);
	}
}