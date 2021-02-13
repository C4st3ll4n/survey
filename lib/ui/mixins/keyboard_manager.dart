import 'package:flutter/material.dart';

mixin KeyboardManager{
	
	void hideKeyboard(BuildContext context) {
		final _currentFocus = FocusScope.of(context);
		if(_currentFocus.hasPrimaryFocus){
			_currentFocus.unfocus();
		}
	}
	
}