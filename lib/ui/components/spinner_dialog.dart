import 'package:flutter/material.dart';

void showSimpleLoading(BuildContext contexto){
	showDialog(
		context: contexto,
		barrierDismissible: true,
		child: SimpleDialog(
			children: [
				Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: [
						CircularProgressIndicator(),
						SizedBox(
							height: 10,
						),
						Text(
							"Aguarde",
							textAlign: TextAlign.center,
						),
					],
				)
			],
		),
	);
}

void hideLoading(BuildContext contexto){
	if (Navigator.of(contexto).canPop()) {
		Navigator.of(contexto).pop();
	}
}