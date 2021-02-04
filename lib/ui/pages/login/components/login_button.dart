import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../login_presenter.dart';

class LoginButton extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		final presenter = Provider.of<LoginPresenter>(context);
		
		return StreamBuilder<bool>(
			stream: presenter.isFormValidStream,
			builder: (context, snapshot) {
				return RaisedButton(
					child: Text("Entrar".toUpperCase()),
					onPressed: snapshot.data == true
							? presenter.auth
							: null,
				);
			},);
	}
}