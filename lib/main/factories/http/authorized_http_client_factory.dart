import 'package:survey/main/factories/http/http.dart';
import '../../decorators/decorators.dart';
import '../cache/cache.dart';

import '../../../data/http/http.dart';

HttpClient makeAuthorizedHttpAdapter() {
  return AuthorizeHttpClientDecorator(
    fetchSecureCacheStorage: makeLocalStorageAdapter(),
    decoratee: makeHttpAdapter(),
  );
}

