import 'package:flutter/material.dart';
import '../components/components.dart';
import '../helpers/helpers.dart';

mixin UIErrorManager {
  void handleError({ @required Stream<UIError> stream, @required BuildContext contexto}) {
    stream.listen((UIError error) {
      if (error != null) {
        showErrorMessage(contexto, error.description);
      }
    }
    );
  }
}
