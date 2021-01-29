import 'package:survey/ui/helpers/helpers.dart';
import 'package:survey/ui/pages/pages.dart';

abstract class SurveysPresenter{
	Stream<bool> get isLoadingStream;
  Stream<List<SurveyViewModel>> get surveysStream;
  
	Future<void> loadData();
}