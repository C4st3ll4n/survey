import 'package:survey/ui/pages/survey_result/survey_result.dart';

abstract class SurveyResultPresenter{
	Stream<bool> get isLoadingStream;
	Stream<SurveyResultViewModel> get surveyResultStream;
	
	Future<void> loadData();
}