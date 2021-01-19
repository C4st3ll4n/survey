import '../helpers.dart';

enum UIError{
	unexpected, invalidCredentials,
	requiredField, invalidField
}

extension UIErrorExtension on UIError{
	String get description{
		switch(this){
			
		  case UIError.unexpected:
		    return R.strings.msgUnexpectedError;
		    break;
		  case UIError.invalidCredentials:
		    return R.strings.msgInvalidCredentials;
		    break;
			case UIError.invalidField:
				return "Campo inválido.";
				break;
			case UIError.requiredField:
				return "Campo obrigatório.";
				break;
			default: return "Algo errado aconteceu. Tente novamente.";
		}
	}
}