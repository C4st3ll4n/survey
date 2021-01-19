enum UIError{
	unexpected, invalidCredentials,
	requiredField, invalidField
}

extension UIErrorExtension on UIError{
	String get description{
		switch(this){
			
		  case UIError.unexpected:
		    return "Erro inesperado.";
		    break;
		  case UIError.invalidCredentials:
		    return "Credenciais inválidas.";
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