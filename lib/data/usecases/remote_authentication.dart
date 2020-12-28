import 'package:meta/meta.dart';
import 'package:survey/data/models/remote_account_model.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../domain/entities/entities.dart';

import '../http/http.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({@required this.httpClient, @required this.url});

  Future<AccountEntity> auth(AuthenticationParams authenticationParams) async {
    //final Map body = {'email':authenticationParams.email, 'password':authenticationParams.secret};
    try {
      final body =
          RemoteAuthenticationParams.fromDomain(authenticationParams).toJson();
      final response = await httpClient.request(url: url, method: 'post', body: body);
      return RemoteAccountModel.fromJson(response).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.unauthorized
          ? DomainError.invalidCredentials
          : DomainError.unexpected;
    }
  }
}

class RemoteAuthenticationParams {
  final String email;
  final String password;

  RemoteAuthenticationParams({@required this.email, @required this.password});

  factory RemoteAuthenticationParams.fromDomain(AuthenticationParams entity) =>
      RemoteAuthenticationParams(email: entity.email, password: entity.secret);

  Map toJson() => {'email': email, 'password': password};
}
