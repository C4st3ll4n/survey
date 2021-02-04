import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../helpers/errors/errors.dart';
import '../login_presenter.dart';

class PasswordInput extends StatelessWidget {
	const PasswordInput({
		Key key,
	}) : super(key: key);
	
	@override
	Widget build(BuildContext context) {
		final presenter = Provider.of<LoginPresenter>(context);
		return StreamBuilder<UIError>(
			stream: presenter.passwordErrorStream,
			builder: (ctx, snap) => TextFormField(
				onChanged: presenter.validatePassword,
				decoration: InputDecoration(
					labelText: "Senha",
					errorText: snap.hasData? snap.data.description:null,
					icon: Icon(
						Icons.lock,
						color: Theme.of(context).primaryColorLight,
					),
				),
				keyboardType: TextInputType.visiblePassword,
				obscureText: true,
			),
		);
	}
}
