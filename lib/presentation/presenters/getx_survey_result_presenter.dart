import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:survey/domain/helpers/domain_error.dart';
import 'package:survey/ui/helpers/errors/errors.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';

class GetXSurveyResultPresenter implements SurveyResultPresenter {
  GetXSurveyResultPresenter({@required this.loadSurveyResult});

  final LoadSurveyResult loadSurveyResult;

  var _isLoading = true.obs;
  var _dataStream = Rx<SurveyResultViewModel>();

  @override
  Stream<bool> get isLoadingStream => _isLoading.stream.distinct();

  @override
  Future<void> loadData() async{
    _isLoading.value = true;
    try {
      final entity = await loadSurveyResult.loadBySurvey();
      _dataStream.value = SurveyResultViewModel.fromEntity(entity);
    } on DomainError catch (e) {
      _dataStream.addError(UIError.unexpected.description, StackTrace.empty);
    }
    finally {
      _isLoading.value = false;
    }
  }

  @override
  Stream<SurveyResultViewModel> get surveyResultStream =>
      _dataStream.stream.distinct();
}
