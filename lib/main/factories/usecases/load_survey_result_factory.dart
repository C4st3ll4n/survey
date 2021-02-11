import '../factories.dart';
import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';

LoadSurveyResult makeLoadSurveyResult(String surveyID) {
	return RemoteLoadSurveyResult(httpClient: makeHttpAdapter(),
			url: makeAPIUrl("surveys/$surveyID/results"));
}