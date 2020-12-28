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
  AuthenticationParams params;

  /// Test setup
  /// Configurando HttpClient, URL, System Under Test (SUT) e
  /// AuthenticationParams
  setUp(
    () {
      httpClient = HttpClientSpy();
      url = faker.internet.httpUrl();
      sut = RemoteAuthentication(httpClient: httpClient, url: url);
      params = AuthenticationParams(
        email: faker.internet.email(),
        secret: faker.internet.password(),
      );
    },
  );

  test(
    'Should call HttpClient with correct values',
    () async {
      when(
        httpClient.request(
          url: anyNamed("url"),
          method: anyNamed("method"),
          body: anyNamed("body"),
        ),
      ).thenAnswer((_) async {
        final accessToken = faker.guid.guid();
        return {"accessToken": accessToken, "name": faker.person.name()};
      });

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

  /// TEST ON 400
  test(
    "Shoud throw an UnexpectedError if HttpClient returns 400",
    () async {
      when(
        httpClient.request(
          url: anyNamed("url"),
          method: anyNamed("method"),
          body: anyNamed("body"),
        ),
      ).thenThrow(HttpError.badRequest);

      final future = sut.auth(params);

      expect(
        future,
        throwsA(DomainError.unexpected),
      );
    },
  );

  /// TEST ON 404
  test(
    "Shoud throw an UnexpectedError if HttpClient returns 404",
    () async {
      when(
        httpClient.request(
          url: anyNamed("url"),
          method: anyNamed("method"),
          body: anyNamed("body"),
        ),
      ).thenThrow(HttpError.notFound);

      final future = sut.auth(params);

      expect(
        future,
        throwsA(DomainError.unexpected),
      );
    },
  );

  /// TEST ON 500
  test(
    "Shoud throw an UnexpectedError if HttpClient returns 500",
    () async {
      when(
        httpClient.request(
          url: anyNamed("url"),
          method: anyNamed("method"),
          body: anyNamed("body"),
        ),
      ).thenThrow(HttpError.serverError);

      final future = sut.auth(params);

      expect(
        future,
        throwsA(DomainError.unexpected),
      );
    },
  );

  /// TEST ON 500
  test(
    "Shoud throw an InvalidCrendential if HttpClient returns 401",
    () async {
      when(
        httpClient.request(
          url: anyNamed("url"),
          method: anyNamed("method"),
          body: anyNamed("body"),
        ),
      ).thenThrow(HttpError.unauthorized);

      final future = sut.auth(params);

      expect(
        future,
        throwsA(DomainError.invalidCredentials),
      );
    },
  );

  /// TEST ON 200
  test(
    "Shoud return an Account if HttpClient returns 200",
    () async {
      final accessToken = faker.guid.guid();

      when(
        httpClient.request(
          url: anyNamed("url"),
          method: anyNamed("method"),
          body: anyNamed("body"),
        ),
      ).thenAnswer((_) async {
        return {"accessToken": accessToken, "name": faker.person.name()};
      });

      final account = await sut.auth(params);

      expect(account.token, accessToken);
    },
  );

  /// TEST ON 200
  test(
    "Shoud throw an UnexpectedError if HttpClient returns 200 with invalid data",
        () async {
      final accessToken = faker.guid.guid();
    
      when(
        httpClient.request(
          url: anyNamed("url"),
          method: anyNamed("method"),
          body: anyNamed("body"),
        ),
      ).thenAnswer((_) async {
        return {"random": faker.randomGenerator.string(50)};
      });

      final future = sut.auth(params);
      
      expect(
        future,
        throwsA(DomainError.unexpected),
      );    },
  );
}
