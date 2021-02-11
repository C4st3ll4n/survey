import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';
import '../../ui/helpers/errors/errors.dart';
import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';

class GetXSurveysPresenter extends GetxController implements SurveysPresenter {
  GetXSurveysPresenter({@required this.loadSurveys});

  final LoadSurveys loadSurveys;

  var _isLoading = true.obs;
  var _navigate = RxString();
  var _dataStream = RxList<SurveyViewModel>();

  @override
  Stream<bool> get isLoadingStream => _isLoading.stream.distinct();
  
  @override
  Stream<String> get navigateToStream => _navigate.stream.distinct();

  @override
  Stream<List<SurveyViewModel>> get surveysStream =>
      _dataStream.stream.distinct();

  @override
  Future<void> loadData() async {
    _isLoading.value = true;
    try {
      final result = await loadSurveys.load();
      _dataStream.addAll(result
          .map(
            (SurveyEntity e) => SurveyViewModel(
                id: e.id,
                question: e.question,
                formatedDate: DateFormat('dd MMM yyyy').format(e.dateTime),
                didAnswer: e.didAnswer),
          )
          .toList());
    } on DomainError catch(e, stck) {
      _dataStream.subject.
      addError(UIError.unexpected.description, StackTrace.empty);
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  void goToSurveyResult(String id) {
    _navigate.value = "/survey_result/$id";
  }

}
