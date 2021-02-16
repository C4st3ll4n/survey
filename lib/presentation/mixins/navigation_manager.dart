import 'package:get/get.dart';

mixin NavigationManager  on GetxController{
	var _navigateTo = RxString();
	
	Stream<String> get navigationStream => _navigateTo.stream;
	
	set goTo(String route) => _navigateTo.subject.add(route);
}