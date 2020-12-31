import 'package:flutter/material.dart';

void showErrorMessage(BuildContext contexto, String error) {
  Scaffold.of(contexto).showSnackBar(
    SnackBar(
      backgroundColor: Colors.red[900],
      content: Text(
        error,
        textAlign: TextAlign.center,
      ),
    ),
  );
}
