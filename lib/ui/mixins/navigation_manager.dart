import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/components.dart';

mixin NavigationManager {
  void handleNavigation(
      {@required Stream<String> stream, bool clear = false}) {
    stream.listen((page) {
      if (page?.isNotEmpty == true) {
        if(clear ==true){
          Get.offAllNamed(page);
        }else{
          Get.toNamed(page);
        }
      }
    });
  }
}
