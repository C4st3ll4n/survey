import '../factories.dart';
import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';

LoadSurveyResult makeRemoteLoadSurveyResult(String surveyID) {
	return RemoteLoadSurveyResult(httpClient: makeAuthorizedHttpAdapter(),
			url: makeAPIUrl("surveys/$surveyID/results"));
}