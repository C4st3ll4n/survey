import 'package:faker/faker.dart';
import 'package:meta/meta.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/data/cache/cache.dart';
import 'package:survey/data/http/http.dart';
import 'package:survey/infra/http/http.dart';
import 'package:survey/main/decorators/authorize_http_client_decorator.dart';

void main() {
  AuthorizeHttpClientDecorator sut;
  FetchSecureCacheStorage fetchSecureCacheStorageSpy;
  HttpClient httpAdapterSpy;

  String url, method;
  Map body;

  String token;

  String httpResponse;

  PostExpectation _mockFetchSecure() =>
      when(fetchSecureCacheStorageSpy.fetchSecure(any));

  void mockToken() {
    token = faker.guid.guid();
    _mockFetchSecure().thenAnswer((_) async => token);
  }

  void mockTokenError() => _mockFetchSecure().thenThrow(Exception());

  void mockHttpResponse() {
    httpResponse = faker.randomGenerator.string(50);

    when(
      httpAdapterSpy.request(
        url: anyNamed("url"),
        method: anyNamed("method"),
        body: anyNamed("body"),
        headers: anyNamed("headers"),
      ),
    ).thenAnswer((_) async => httpResponse);
  }

  setUp(() {
    fetchSecureCacheStorageSpy = FetchSecureCacheStorageSpy();
    httpAdapterSpy = HttpAdapterSpy();
    sut = AuthorizeHttpClientDecorator(
        fetchSecureCacheStorage: fetchSecureCacheStorageSpy,
        decoratee: httpAdapterSpy);

    url = faker.internet.httpUrl();
    method = faker.randomGenerator.string(10);
    body = {'any_key': "any_value"};

    mockToken();
    mockHttpResponse();
  });

  test("Should call fetchSecureCacheStorage with correct key", () async {
    await sut.request(url: url, method: method, body: body);
    verify(fetchSecureCacheStorageSpy.fetchSecure("token")).called(1);
  });

  test("Should call decoratee with accessToken on header", () async {
    await sut.request(url: url, method: method, body: body);

    verify(httpAdapterSpy.request(
        url: url,
        method: method,
        body: body,
        headers: {'x-access-token': token})).called(1);
  });

  test("Should return same result as decoratee", () async {
    final response = await sut.request(url: url, method: method, body: body);

    expect(response, httpResponse);
  });
  test("Should throw ForbidenError if fetchSecureCacheStorage throws",
      () async {
    mockTokenError();
    final future = sut.request(url: url, method: method, body: body);

    expect(
      future,
      throwsA(HttpError.forbidden),
    );
  });
}

class FetchSecureCacheStorageSpy extends Mock
    implements FetchSecureCacheStorage {}

class HttpAdapterSpy extends Mock implements HttpClient {}
