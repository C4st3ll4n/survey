import 'package:meta/meta.dart';
import 'package:survey/domain/helpers/domain_error.dart';

import '../../domain/usecases/usecases.dart';

import '../http/http.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({@required this.httpClient, @required this.url});

  Future<void> auth(AuthenticationParams authenticationParams) async {
    //final Map body = {'email':authenticationParams.email, 'password':authenticationParams.secret};
    try{
      final body = RemoteAuthenticationParams.fromDomain(authenticationParams)
          .toJson();
      await httpClient.request(
          url: url,
          method: 'post',
          body: body);
    }on HttpError{
      throw DomainError.unexpected;
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
