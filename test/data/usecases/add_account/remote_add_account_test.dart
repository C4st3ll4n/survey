import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/data/http/http.dart';
import 'package:survey/data/models/remote_account_model.dart';
import 'package:survey/domain/entities/account_entity.dart';
import 'package:survey/domain/helpers/helpers.dart';
import 'package:test/test.dart';

import 'package:survey/data/usecases/usecases.dart';
import 'package:survey/domain/usecases/usecases.dart';
import 'package:meta/meta.dart';

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
            "confirmPassword": params.password
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

class RemoteAddAccount implements AddAccount {
  final HttpClient httpClient;
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
