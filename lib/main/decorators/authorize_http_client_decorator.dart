import 'package:meta/meta.dart';
import 'package:survey/data/cache/cache.dart';
import 'package:survey/data/http/http.dart';

class AuthorizeHttpClientDecorator implements HttpClient {
  final FetchSecureCacheStorage fetchSecureCacheStorage;
  final HttpClient decoratee;

  AuthorizeHttpClientDecorator(
      {@required this.fetchSecureCacheStorage, @required this.decoratee});

  @override
  Future<dynamic> request(
      {String url,
      String method,
      Map<dynamic, dynamic> body,
      Map<dynamic, dynamic> headers}) async {
    try {
      String token = await fetchSecureCacheStorage.fetchSecure("token");
      final authorizedHeaders = headers ?? {}
        ..addAll({'x-access-token': token});
      return await decoratee.request(
          url: url, method: method, body: body, headers: authorizedHeaders);
    } on HttpError{
      rethrow;
    }
    catch (error) {
      throw HttpError.forbidden;
    }
  }
}
