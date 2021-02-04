import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../pages.dart';
import '../../../helpers/errors/errors.dart';

class PasswordConfirmationInput extends StatelessWidget {
	const PasswordConfirmationInput({
		Key key,
	}) : super(key: key);
	
	@override
	Widget build(BuildContext context) {
		final presenter = Provider.of<SignUpPresenter>(context);
		return StreamBuilder<UIError>(
			stream: presenter.passwordConfirmationErrorStream,
			builder: (ctx, snap) => TextFormField(
				onChanged: presenter.validatePasswordConfirmation,
				decoration: InputDecoration(
					labelText: "Confirmar senha",
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
