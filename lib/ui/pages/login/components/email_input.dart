import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:survey/ui/helpers/errors/errors.dart';
import '../login_presenter.dart';

class EmailInput extends StatelessWidget {
	
	@override
	Widget build(BuildContext context) {
		final presenter = Provider.of<LoginPresenter>(context);
		return StreamBuilder<UIError>(
			stream: presenter.emailErrorStream,
			builder: (ctx, snap) => TextFormField(
				onChanged: presenter.validateEmail,
				decoration: InputDecoration(
					errorText: snap.hasData? snap.data.description:null,
					
					labelText: "Email",
					icon: Icon(
						Icons.email,
						color: Theme.of(context).primaryColorLight,
					),
				),
				keyboardType: TextInputType.emailAddress,
			),
		);
	}
}