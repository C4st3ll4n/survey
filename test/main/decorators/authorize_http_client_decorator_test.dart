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
  
  void mockToken(){
    token = faker.guid.guid();
  
    when(
      fetchSecureCacheStorageSpy.fetchSecure(any)
    ).thenAnswer((_) async => token);
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
}

class FetchSecureCacheStorageSpy extends Mock
    implements FetchSecureCacheStorage {}

class HttpAdapterSpy extends Mock implements HttpClient {}
