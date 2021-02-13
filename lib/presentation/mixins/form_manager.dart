import 'package:get/get.dart';

mixin FormManager on GetxController{
	final _isFormValid = false.obs;
	Stream<bool> get validFormStream => _isFormValid.stream.distinct();
	
	set formStatus(bool value) => _isFormValid.value = value;
}