
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:survey/ui/pages/login/login_presenter.dart';

class PasswordInput extends StatelessWidget {
	const PasswordInput({
		Key key,
	}) : super(key: key);
	
	@override
	Widget build(BuildContext context) {
		final presenter = Provider.of<LoginPresenter>(context);
		return StreamBuilder<String>(
			stream: presenter.passwordErrorStream,
			builder: (ctx, snap) => Padding(
				padding:
				const EdgeInsets.only(top: 8.0, bottom: 32),
				child: TextFormField(
					onChanged: presenter.validatePassword,
					decoration: InputDecoration(
						labelText: "Senha",
						errorText: snap.data?.isEmpty == true
								? null
								: snap.data,
						icon: Icon(
							Icons.lock,
							color: Theme.of(context).primaryColorLight,
						),
					),
					keyboardType: TextInputType.visiblePassword,
					obscureText: true,
				),
			),
		);
	}
}
