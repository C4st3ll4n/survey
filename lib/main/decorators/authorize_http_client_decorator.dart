import 'package:meta/meta.dart';
import '../../data/cache/cache.dart';
import '../../data/http/http.dart';

class AuthorizeHttpClientDecorator implements HttpClient {
  final FetchSecureCacheStorage fetchSecureCacheStorage;
  final HttpClient decoratee;

  final DeleteSecureCacheStorage deleteSecureCacheStorage;

  AuthorizeHttpClientDecorator(
      {@required this.fetchSecureCacheStorage, @required this.decoratee, @required this.deleteSecureCacheStorage});

  @override
  Future<dynamic> request(
      {String url,
      String method,
      Map<dynamic, dynamic> body,
      Map<dynamic, dynamic> headers}) async {
    try {
      String token = await fetchSecureCacheStorage.fetch("token");
      final authorizedHeaders = headers ?? {}
        ..addAll({'x-access-token': token});
      return await decoratee.request(
          url: url, method: method, body: body, headers: authorizedHeaders);
    }
    catch (error, stck) {
      if( error is HttpError && error != HttpError.forbidden){
        rethrow;
      }
      await deleteToken();
      throw HttpError.forbidden;
    }
  }
  
  Future deleteToken() async{
    await deleteSecureCacheStorage.delete('token');
  }
}
