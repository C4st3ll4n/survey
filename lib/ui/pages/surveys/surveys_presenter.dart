import '../pages.dart';

abstract class SurveysPresenter{
	Stream<bool> get  isSessionExpiredStream;

  Stream<String> get navigateToStream;

	Stream<bool> get isLoadingStream;
  Stream<List<SurveyViewModel>> get surveysStream;
  
	Future<void> loadData();

  void goToSurveyResult(String id);
}