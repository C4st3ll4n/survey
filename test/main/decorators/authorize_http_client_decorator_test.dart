import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/data/cache/cache.dart';
import 'package:survey/data/http/http.dart';
import 'package:survey/main/decorators/decorators.dart';

void main() {
  AuthorizeHttpClientDecorator sut;
  FetchSecureCacheStorage fetchSecureCacheStorageSpy;
  DeleteSecureCacheStorage deleteSecureCacheStorageSpy;
  HttpClient httpAdapterSpy;

  String url, method;
  Map body;

  String token;

  String httpResponse;

  PostExpectation _mockFetchSecure() =>
      when(fetchSecureCacheStorageSpy.fetch(any));

  PostExpectation _mockHttpAdapter() => when(
        httpAdapterSpy.request(
          url: anyNamed("url"),
          method: anyNamed("method"),
          body: anyNamed("body"),
          headers: anyNamed("headers"),
        ),
      );

  void mockToken() {
    token = faker.guid.guid();
    _mockFetchSecure().thenAnswer((_) async => token);
  }

  void mockTokenError() => _mockFetchSecure().thenThrow(Exception());

  void mockHttpResponse() {
    httpResponse = faker.randomGenerator.string(50);
    _mockHttpAdapter().thenAnswer((_) async => httpResponse);
  }
  
  void mockHttpResponseFail(HttpError error) => _mockHttpAdapter()..thenThrow(error);

  setUp(() {
    deleteSecureCacheStorageSpy = DeleteSecureCacheStorageSpy();
    fetchSecureCacheStorageSpy = FetchSecureCacheStorageSpy();
    httpAdapterSpy = HttpAdapterSpy();
    sut = AuthorizeHttpClientDecorator(
        fetchSecureCacheStorage: fetchSecureCacheStorageSpy,
        deleteSecureCacheStorage: deleteSecureCacheStorageSpy,
        decoratee: httpAdapterSpy);

    url = faker.internet.httpUrl();
    method = faker.randomGenerator.string(10);
    body = {'any_key': "any_value"};

    mockToken();
    mockHttpResponse();
  });

  test("Should call fetchSecureCacheStorage with correct key", () async {
    await sut.request(url: url, method: method, body: body);
    verify(fetchSecureCacheStorageSpy.fetch("token")).called(1);
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

    verify(deleteSecureCacheStorageSpy.delete("token")).called(1);
  
      });

  test("Should rethrow exection if decoratee throws", () async {
    mockHttpResponseFail(HttpError.badRequest);
    final future = sut.request(url: url, method: method, body: body);

    expect(
      future,
      throwsA(HttpError.badRequest),
    );

  });


  test("Should delete token if decoratee throws", () async {
    mockHttpResponseFail(HttpError.forbidden);
    final future = sut.request(url: url, method: method, body: body);
    await untilCalled(deleteSecureCacheStorageSpy.delete("token"));
    
    expect(
      future,
      throwsA(HttpError.forbidden),
    );
    verify(deleteSecureCacheStorageSpy.delete("token")).called(1);

  
  });
  
  
  
}


class DeleteSecureCacheStorageSpy extends Mock
    implements DeleteSecureCacheStorage {}
    
class FetchSecureCacheStorageSpy extends Mock
    implements FetchSecureCacheStorage {}

class HttpAdapterSpy extends Mock implements HttpClient {}
