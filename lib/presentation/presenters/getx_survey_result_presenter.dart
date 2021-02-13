import 'package:get/get.dart';
import 'package:meta/meta.dart';
import '../mixins/mixins.dart';
import '../../domain/helpers/domain_error.dart';
import '../../ui/helpers/errors/errors.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';

class GetXSurveyResultPresenter extends GetxController  with SessionManager, LoadingManager implements SurveyResultPresenter {
  GetXSurveyResultPresenter({@required this.loadSurveyResult, @required this.surveyId});

  final LoadSurveyResult loadSurveyResult;
  final String surveyId;
  
  var _dataStream = Rx<SurveyResultViewModel>();

  @override
  Stream<bool> get isLoadingStream => loadingStream;
  
  Stream<bool> get isSessionExpiredStream => sessionStream;

  @override
  Future<void> loadData() async{
    isLoading = true;
    try {
      final entity = await loadSurveyResult.loadBySurvey(surveyId: surveyId);
      _dataStream.value = SurveyResultViewModel.fromEntity(entity);
    } on DomainError catch (e) {
      if (e == DomainError.accessDenied) {
        isExpired = true;
      } else {
        _dataStream.subject
            .addError(UIError.unexpected.description, StackTrace.empty);
      }
    }
    finally {
      isLoading = false;
    }
  }

  @override
  Stream<SurveyResultViewModel> get surveyResultStream =>
      _dataStream.stream.distinct();
}
