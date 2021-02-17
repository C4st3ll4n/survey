import 'dart:developer';

import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:survey/domain/entities/entities.dart';
import '../mixins/mixins.dart';
import '../../domain/helpers/domain_error.dart';
import '../../ui/helpers/errors/errors.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';

class GetXSurveyResultPresenter extends GetxController
    with SessionManager, LoadingManager
    implements SurveyResultPresenter {
  GetXSurveyResultPresenter({
    @required this.loadSurveyResult,
    @required this.surveyId,
    @required this.saveSurveyResult,
  });

  final LoadSurveyResult loadSurveyResult;
  final SaveSurveyResult saveSurveyResult;
  final String surveyId;

  var _dataStream = Rx<SurveyResultViewModel>();

  @override
  Stream<bool> get isLoadingStream => loadingStream;

  Stream<bool> get isSessionExpiredStream => sessionStream;

  @override
  Future<void> loadData() async {
    _process(() => loadSurveyResult.loadBySurvey(surveyId: surveyId));
  }
  
  @override
  Future<void> save({String answer}) async {
    _process(() => saveSurveyResult.save(answer: answer));
  }

  @override
  Stream<SurveyResultViewModel> get surveyResultStream =>
      _dataStream.stream.distinct();

  Future<void> _process(Future<SurveyResultEntity> action()) async {
    isLoading = true;
    try {
      final entity = await action();
      _dataStream.subject.add(SurveyResultViewModel.fromEntity(entity));
    } on DomainError catch (e) {
      if (e == DomainError.accessDenied) {
        isExpired = true;
      } else {
        _dataStream.subject
            .addError(UIError.unexpected.description, StackTrace.empty);
      }
    } catch(e, stck){
      log(e.toString(), stackTrace: stck);
    }
    finally {
      isLoading = false;
    }
  }

}
