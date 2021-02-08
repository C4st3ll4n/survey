abstract class SurveyResultPresenter{
	Stream<bool> get isLoadingStream;
	Stream get surveyResultStream;
	
	Future<void> loadData();
}