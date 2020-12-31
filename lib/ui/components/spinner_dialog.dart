import 'package:flutter/material.dart';

void showSimpleLoading(BuildContext contexto){
	showDialog(
		context: contexto,
		barrierDismissible: false,
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
	if (Navigator.canPop(contexto)) {
		Navigator.pop(contexto);
	}
}