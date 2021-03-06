import 'package:get/get.dart';

mixin LoadingManager  on GetxController{
	final _isLoading = true.obs;
	Stream<bool> get loadingStream => _isLoading.stream.distinct();
	
	set isLoading(bool value) => _isLoading.value = value;
}