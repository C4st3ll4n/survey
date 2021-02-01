import 'package:http/http.dart';
import '../../decorators/decorators.dart';
import '../cache/cache.dart';

import '../../../data/http/http.dart';
import '../../../infra/http/http.dart';

HttpClient makeAuthorizedHttpAdapter() {
  final client = Client();
  return AuthorizeHttpClientDecorator(
    fetchSecureCacheStorage: makeLocalStorageAdapter(),
    decoratee: HttpAdapter(client),
  );
}

