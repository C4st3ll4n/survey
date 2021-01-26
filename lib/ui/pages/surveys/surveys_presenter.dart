import 'package:survey/ui/helpers/helpers.dart';
import 'package:survey/ui/pages/pages.dart';

abstract class SurveysPresenter{
	Stream<bool> isLoadingStream;
  Stream<List<SurveyViewModel>> loadSurveysStream;
  
	Future<void> loadData();
}