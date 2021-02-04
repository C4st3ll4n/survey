import 'package:flutter/widgets.dart';
import 'strings/strings.dart';

class R{
	static Translations strings = PtBR();
	
	static void load(Locale locale){
		switch(locale.toString()){
			case 'en_US': strings = EnUS(); break;
			default: strings = PtBR(); break;
		}
	}
}