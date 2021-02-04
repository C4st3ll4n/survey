import 'package:equatable/equatable.dart';
import '../entities/entities.dart';

abstract class AddAccount {
  Future<AccountEntity> register(RegisterParams params) {}
}

class RegisterParams extends Equatable {
  final String email;
  final String name;
  final String password;
  final String passwordConfirmation;

  RegisterParams(
      {this.email, this.name,
	      this.password, this.passwordConfirmation});

  @override
  List<Object> get props => [email, name, password];
}
