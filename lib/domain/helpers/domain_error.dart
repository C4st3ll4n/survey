enum DomainError{
	unexpected, invalidCredentials
}

extension DomainErrorExtension on DomainError{
	String get description{
		switch(this){
			
		  case DomainError.unexpected:
		    return "Erro inesperado.";
		    break;
		  case DomainError.invalidCredentials:
		    return "Credenciais inválidas.";
		    break;
			default: return "";
		}
	}
}