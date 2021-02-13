import 'package:get/get.dart';

mixin NavigationManager{
	var _navigateTo = RxString();
	
	Stream<String> get navigationStream => _navigateTo.stream.distinct();
	
	set goTo(String route) => _navigateTo.value = route;
}