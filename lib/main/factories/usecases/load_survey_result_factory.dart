import '../factories.dart';
import '../../composites/composites.dart';
import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';

LoadSurveyResult makeLoadSurveyResult(String surveyID) {
  return RemoteLoadSurveyResultWithLocalFallback(
      remote: _makeRemoteLoadSurveyResult(surveyID), local: _makeLocalLoadSurveyResult(surveyID));
}

LoadSurveyResult _makeRemoteLoadSurveyResult(String surveyId) =>
    RemoteLoadSurveyResult(
      httpClient: makeAuthorizedHttpAdapter(),
      url: makeAPIUrl("surveys/$surveyId/results"),
    );

LoadSurveyResult _makeLocalLoadSurveyResult(String surveyId) =>
    LocalLoadSurveyResult(cacheStorage: makeLocalStorageAdapter());//FIXME