import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/components.dart';

mixin NavigationManager {
  void handleNavigation(
      {@required Stream<String> stream, @required BuildContext contexto}) {
    stream.listen((page) {
      if (page?.isNotEmpty == true) {
        Get.toNamed(page);
      }
    });
  }
}
