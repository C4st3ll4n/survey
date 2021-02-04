import 'load_surveys_factory.dart';
import '../../../../ui/pages/pages.dart';
import '../../../../presentation/presenters/presenters.dart';

SurveysPresenter makeGetXSurveyPresenter() => GetXSurveysPresenter(loadSurveys: makeLoadsurveys());