import '../../../../ui/pages/pages.dart';
import '../../../../presentation/presenters/presenters.dart';
import 'load_surveys_factory.dart';

SurveysPresenter makeGetXSurveyPresenter() => GetXSurveysPresenter(loadSurveys: makeLoadsurveys());