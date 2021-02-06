import '../../factories.dart';
import '../../../composites/composites.dart';
import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/usecases.dart';

LoadSurveys makeRemoteLoadsurveys() => RemoteLoadSurveys(
    httpClient: makeAuthorizedHttpAdapter(), url: makeAPIUrl("surveys"));

LoadSurveys makeLocalLoadsurveys() =>
    LocalLoadSurveys(cacheStorage: makeLocalStorageAdapter());

LoadSurveys makeRemoteLoadsurveysWithLocalFallback() =>
    RemoteLoadSurveysWithLocalFallback(
        remote: makeRemoteLoadsurveys(), local: makeLocalLoadsurveys());
