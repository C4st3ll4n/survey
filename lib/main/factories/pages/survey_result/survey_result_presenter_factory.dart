import '../../usecases/usecases.dart';
import '../../../../ui/pages/pages.dart';
import '../../../../presentation/presenters/presenters.dart';

SurveyResultPresenter makeGetXSurveyResultPresenter(String surveyId)
=> GetXSurveyResultPresenter(loadSurveyResult: makeLoadSurveyResult(surveyId),
		surveyId: surveyId);
