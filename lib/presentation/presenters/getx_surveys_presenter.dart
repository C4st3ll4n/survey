import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';
import '../mixins/mixins.dart';
import '../../ui/helpers/errors/errors.dart';
import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';

class GetXSurveysPresenter extends GetxController
    with SessionManager, LoadingManager, NavigationManager
    implements SurveysPresenter {
  GetXSurveysPresenter({@required this.loadSurveys});

  final LoadSurveys loadSurveys;

  var _dataStream = RxList<SurveyViewModel>();

  @override
  Stream<bool> get isLoadingStream => loadingStream;

  @override
  Stream<bool> get isSessionExpiredStream => sessionStream;

  @override
  Stream<String> get navigateToStream => navigationStream;

  @override
  Stream<List<SurveyViewModel>> get surveysStream =>
      _dataStream.stream.distinct();

  @override
  Future<void> loadData() async {
    isLoading = true;
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
    } on DomainError catch (e, stck) {
      if (e == DomainError.accessDenied) {
        isExpired = true;
      } else {
        _dataStream.subject
            .addError(UIError.unexpected.description, StackTrace.empty);
      }
    } finally {
      isLoading = false;
    }
  }

  @override
  void goToSurveyResult(String id) {
    goTo = "/survey_result/$id";
  }
}
