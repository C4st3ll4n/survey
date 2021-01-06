import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';
import '../factories.dart';

Authentication makeRemoteAuthentication() => RemoteAuthentication(httpClient: makeHttpAdapter(), url: makeAPIUrl("login"));
