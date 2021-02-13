import 'package:get/get.dart';

mixin LoadingManager{
	final _isLoading = false.obs;
	Stream<bool> get loadingStream => _isLoading.stream.distinct();
	
	set isLoading(bool value) => _isLoading.value = value;
}