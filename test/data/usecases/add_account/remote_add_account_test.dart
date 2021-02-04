import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/data/http/http.dart';
import 'package:survey/data/usecases/usecases.dart';
import 'package:survey/domain/helpers/helpers.dart';
import 'package:test/test.dart';
import 'package:survey/domain/usecases/usecases.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  AddAccount sut;
  HttpClient httpClient;
  String url;
  RegisterParams params;

  PostExpectation _mockRequest() => when(
        httpClient.request(
          url: anyNamed("url"),
          method: anyNamed("method"),
          body: anyNamed("body"),
        ),
      );

  void _mockHttpData(Map data) => _mockRequest().thenAnswer((_) async => data);

  void _mockHttpError(HttpError httpError) =>
      _mockRequest().thenThrow(httpError);

  Map _mockValidData() =>
      {"accessToken": faker.guid.guid(), "name": faker.person.name()};

  /// Test setup
  /// Configurando HttpClient, URL, System Under Test (SUT) e
  /// AuthenticationParams
  setUp(
    () {
      httpClient = HttpClientSpy();
      url = faker.internet.httpUrl();
      sut = RemoteAddAccount(httpClient: httpClient, url: url);

      String password = faker.internet.password();
      params = RegisterParams(
          email: faker.internet.email(),
          password: password,
          passwordConfirmation: password,
          name: faker.person.name());
      //Always mock a success valid data
      _mockHttpData(_mockValidData());
    },
  );

  test(
    'Should call HttpClient with correct values',
    () async {
      await sut.register(params);

      verify(
        httpClient.request(
          url: url,
          method: 'post',
          body: {
            'email': params.email,
            'password': params.password,
            "name": params.name,
            "passwordConfirmation": params.password
          },
        ),
      );
    },
  );

  /// TEST ON 400
  test(
    "Shoud throw an UnexpectedError if HttpClient returns 400",
    () async {
      _mockHttpError(HttpError.badRequest);

      final future = sut.register(params);

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
      _mockHttpError(HttpError.notFound);

      final future = sut.register(params);

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
      _mockHttpError(HttpError.serverError);

      final future = sut.register(params);

      expect(
        future,
        throwsA(DomainError.unexpected),
      );
    },
  );

  /// TEST ON 401
  test(
    "Shoud throw an InvalidCrendential if HttpClient returns 403",
    () async {
      _mockHttpError(HttpError.forbidden);

      final future = sut.register(params);

      expect(
        future,
        throwsA(DomainError.emailInUse),
      );
    },
  );

  /// TEST ON 200
  test(
    "Shoud return an Account if HttpClient returns 200",
    () async {
      final validData = _mockValidData();
      _mockHttpData(validData);

      final account = await sut.register(params);

      expect(account.token, validData['accessToken']);
    },
  );

  /// TEST ON 200
  test(
    "Shoud throw an UnexpectedError if HttpClient returns 200 with invalid data",
    () async {
      _mockHttpData({"random": faker.randomGenerator.string(50)});

      final future = sut.register(params);

      expect(
        future,
        throwsA(DomainError.unexpected),
      );
    },
  );
}

