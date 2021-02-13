import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
	if (Navigator.of(contexto).canPop()) {
		Navigator.of(contexto).pop();
	}
}