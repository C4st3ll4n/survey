import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';
import '../factories.dart';

SaveSurveyResult makeSaveSurveyResult(String surveyID) {
	return RemoteSaveSurveyResult(httpClient: makeAuthorizedHttpAdapter(), url: makeAPIUrl("surveys/$surveyID/results"));
}