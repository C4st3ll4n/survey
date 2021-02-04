import '../factories.dart';
import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';

Authentication makeRemoteAuthentication() => RemoteAuthentication(httpClient: makeHttpAdapter(), url: makeAPIUrl("login"));
