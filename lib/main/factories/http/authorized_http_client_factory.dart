import 'package:http/http.dart';
import 'package:survey/main/decorators/decorators.dart';
import 'package:survey/main/factories/cache/cache.dart';

import '../../../data/http/http.dart';
import '../../../infra/http/http.dart';

HttpClient makeAuthorizedHttpAdapter() {
  final client = Client();
  return AuthorizeHttpClientDecorator(
    fetchSecureCacheStorage: makeLocalStorageAdapter(),
    decoratee: HttpAdapter(client),
  );
}

