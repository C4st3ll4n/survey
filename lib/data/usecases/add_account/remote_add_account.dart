import 'package:meta/meta.dart';
import '../../models/remote_account_model.dart';
import '../../http/http.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';

class RemoteAddAccount implements AddAccount {
  final HttpClient<Map> httpClient;
  final String url;

  RemoteAddAccount({this.httpClient, this.url});

  @override
  Future<AccountEntity> register(RegisterParams params) async {
    final _body = RemoteRegisterParams.fromDomain(params).toJson();
    try {
      final response =
          await httpClient.request(url: url, method: "post", body: _body);

      return RemoteAccountModel.fromJson(response).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.forbidden
          ? DomainError.emailInUse
          : DomainError.unexpected;
    }
  }
}

class RemoteRegisterParams {
  final String email;
  final String name;
  final String password;
  final String passwordConfirmation;

  RemoteRegisterParams(
      {@required this.email,
      @required this.name,
      @required this.passwordConfirmation,
      @required this.password});

  factory RemoteRegisterParams.fromDomain(RegisterParams entity) =>
      RemoteRegisterParams(
        email: entity.email,
        password: entity.password,
        name: entity.name,
        passwordConfirmation: entity.passwordConfirmation,
      );

  Map toJson() => {
        'email': email,
        'password': password,
        'name': name,
        "confirmPassword": passwordConfirmation
      };
}
