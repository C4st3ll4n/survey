import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../factories.dart';

LoadSurveys makeLoadsurveys() => RemoteLoadSurveys(
    httpClient: makeAuthorizedHttpAdapter(), url: makeAPIUrl("surveys"));
