import '../../factories.dart';
import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/usecases.dart';

LoadSurveys makeLoadsurveys() => RemoteLoadSurveys(
    httpClient: makeAuthorizedHttpAdapter(), url: makeAPIUrl("surveys"));
