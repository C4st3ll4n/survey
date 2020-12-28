import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/data/http/http.dart';
import 'package:survey/domain/helpers/helpers.dart';
import 'package:test/test.dart';

import 'package:survey/data/usecases/usecases.dart';
import 'package:survey/domain/usecases/usecases.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  RemoteAuthentication sut;
  HttpClient httpClient;
  String url;
  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
  });
  test(
    'Should call HttpClient with correct values',
    () async {
      final AuthenticationParams params = AuthenticationParams(email: faker.internet.email(), secret: faker.internet.password());
      await sut.auth(params);

      verify(
        httpClient.request(
          url: url,
          method: 'post',
          body: {'email': params.email, 'password': params.secret},
        ),
      );
    },
  );
  
  test("Shoud throw an UnexpectedError if HttpClient returns 400", () async{
    when(httpClient.request(url: anyNamed("url"), method: anyNamed("method"),
    body: anyNamed("body"))).thenThrow(HttpError.badRequest);
    
    final AuthenticationParams params = AuthenticationParams(email: faker.internet.email(), secret: faker.internet.password());
    final future = sut.auth(params);
    
    expect(future, throwsA(DomainError.unexpected));
    
  });
}

