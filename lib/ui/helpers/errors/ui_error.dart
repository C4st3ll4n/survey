import '../helpers.dart';

enum UIError {
	unexpected,
	invalidCredentials,
	requiredField,
	invalidField,
	emailInUse,
	shortField,
	longField,
	unmatchField
}

extension UIErrorExtension on UIError{
	String get description {
		switch (this) {
			case UIError.emailInUse:
				return R.strings.msgEmailInUse;
				break;
			case UIError.unexpected:
				return R.strings.msgUnexpectedError;
				break;
			case UIError.invalidCredentials:
				return R.strings.msgInvalidCredentials;
				break;
			case UIError.invalidField:
				return R.strings.msgInvalidField;
				break;
			case UIError.requiredField:
				return R.strings.msgRequiredField;
				break;
		  case UIError.shortField:
		    return "Campo muito curto.";
		    break;
		  case UIError.longField:
			  return "Campo muito longo.";
		    break;
		  case UIError.unmatchField:
		    return R.strings.msgUnmatchField;
		    break;
			default:
				return "Algo errado aconteceu. Tente novamente.";
		}
	}
}