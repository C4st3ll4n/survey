import 'package:get/get.dart';

mixin SessionManager{
	final _isSessionExpired = false.obs;
	Stream<bool> get sessionStream => _isSessionExpired.stream.distinct();
	
	set isExpired(bool value) => _isSessionExpired.value = value;
}