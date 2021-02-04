import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../pages.dart';
import '../../../helpers/helpers.dart';

class EmailInput extends StatelessWidget {
	
	@override
	Widget build(BuildContext context) {
		final presenter = Provider.of<SignUpPresenter>(context);
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