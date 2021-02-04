import 'http.dart';
import '../cache/cache.dart';
import '../../decorators/decorators.dart';
import '../../../data/http/http.dart';

HttpClient makeAuthorizedHttpAdapter() {
  return AuthorizeHttpClientDecorator(
    fetchSecureCacheStorage: makeLocalStorageAdapter(),
    decoratee: makeHttpAdapter(),
  );
}

