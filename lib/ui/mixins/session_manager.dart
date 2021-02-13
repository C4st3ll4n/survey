import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/components.dart';

mixin SessionManager {
  void handleSession({ @required Stream<bool> stream, @required BuildContext contexto}) {
    stream.listen(
            (isExpired) {
          if (isExpired==true) {
            Get.offAllNamed("/login");
          }
        }
    );
  }
}
