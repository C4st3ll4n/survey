import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../pages.dart';
import '../../../helpers/errors/errors.dart';

class NameInput extends StatelessWidget {
	
	@override
	Widget build(BuildContext context) {
		final presenter = Provider.of<SignUpPresenter>(context);
		return StreamBuilder<UIError>(
			stream: presenter.nameErrorStream,
			builder: (ctx, snap) => TextFormField(
				onChanged: presenter.validateName,
				decoration: InputDecoration(
					errorText: snap.hasData? snap.data.description:null,
					labelText: "Nome",
					icon: Icon(
						Icons.person,
						color: Theme.of(context).primaryColorLight,
					),
				),
				keyboardType: TextInputType.name,
			),
		);
	}
}