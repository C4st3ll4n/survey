import 'package:get/get.dart';
import 'package:survey/ui/helpers/helpers.dart';

mixin UIErrorManager on GetxController{
	final _mainError = Rx<UIError>();
	Stream<UIError> get uiErrorStream => _mainError.stream.distinct();
	
	set uiError(UIError value) => _mainError.value = value;
}