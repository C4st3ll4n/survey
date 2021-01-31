import 'package:meta/meta.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/data/cache/cache.dart';
import 'package:survey/data/http/http.dart';

void main(){
	AuthorizeHttpClientDecorator sut;
	FetchSecureCacheStorage fetchSecureCacheStorageSpy;
	setUp((){
		fetchSecureCacheStorageSpy = FetchSecureCacheStorageSpy();
		sut = AuthorizeHttpClientDecorator(fetchSecureCacheStorage:fetchSecureCacheStorageSpy);
	});
	
	test("Should call fetchSecureCacheStorage with correct key",()async{
		await sut.request();
		verify(fetchSecureCacheStorageSpy.fetchSecure("token")).called(1);
	});
}

class FetchSecureCacheStorageSpy extends Mock implements FetchSecureCacheStorage {}

class AuthorizeHttpClientDecorator implements HttpClient{
  FetchSecureCacheStorage fetchSecureCacheStorage;

  AuthorizeHttpClientDecorator(
		  {@required this.fetchSecureCacheStorage});

  @override
  Future request({String url, String method, Map<dynamic, dynamic> body, Map<dynamic, dynamic> headers}) async{
  	await fetchSecureCacheStorage.fetchSecure("token");
  }
	
}