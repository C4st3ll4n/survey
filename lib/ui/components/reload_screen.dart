import 'package:flutter/material.dart';
import 'package:survey/ui/helpers/helpers.dart';

class ReloadScreen extends StatelessWidget {
	
	final String error;
	final Future<void> Function() reload;
	
	const ReloadScreen({
		Key key, this.error, this.reload,
	}) : super(key: key);
	
	@override
	Widget build(BuildContext context) {
		return Padding(
			padding: const EdgeInsets.all(40.0),
			child: Column(
				mainAxisAlignment: MainAxisAlignment.center,
				children: [
					Text("$error", style: TextStyle(
						fontSize: 16,
					),textAlign: TextAlign.center,),
					SizedBox(height: 10,),
					RaisedButton(
						onPressed: reload,
						child: Text(R.strings.reload),
					),
				],
			),
		);
	}
}
