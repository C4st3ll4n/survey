import 'package:flutter/material.dart';
import '../components/components.dart';

mixin LoadingManager {
  void handleLoading({ @required Stream<bool> stream, @required BuildContext contexto}) {
    stream.listen(
      (isLoading) {
        if (isLoading) {
          showSimpleLoading(contexto);
        } else {
          hideLoading(contexto);
        }
      },
    );
  }
}
