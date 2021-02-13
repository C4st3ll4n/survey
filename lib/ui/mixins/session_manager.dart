import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/components.dart';

mixin SessionManager {
  void handleSession({ @required Stream<bool> stream}) {
    stream.listen(
            (isExpired) {
          if (isExpired==true) {
            Get.offAllNamed("/login");
          }
        }
    );
  }
}
