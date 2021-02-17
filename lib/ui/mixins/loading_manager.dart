import 'dart:developer';

import 'package:flutter/material.dart';
import '../components/components.dart';

mixin LoadingManager {
  void handleLoading({ @required Stream<bool> stream, @required BuildContext contexto}) {
    stream.listen(
      (isLoading) {
        log("loading:$isLoading");
        if (isLoading==true) {
          showSimpleLoading(contexto);
        } else {
          hideLoading(contexto);
        }
      },
    );
  }
}
