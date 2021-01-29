import 'package:get/get.dart';
import 'package:meta/meta.dart';
import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';

class GetXSurveysPresenter extends GetxController implements SurveysPresenter {
	GetXSurveysPresenter({@required this.loadSurveys});
	
	final LoadSurveys loadSurveys;
	
	var _isLoading = false.obs;
	var _dataStream = RxList<SurveyViewModel>();
	
	@override
	Stream<bool> get isLoadingStream => _isLoading.stream.distinct();
	
	@override
	Stream<List<SurveyViewModel>> get loadSurveysStream =>
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
						formatedDate: e.dateTime.toString(), //FIXME
						didAnswer: e.didAnswer),
			)
					.toList());
		} on DomainError catch (error) {
			switch (error) {
				case DomainError.unexpected:
				// TODO: Handle this case.
					break;
				case DomainError.invalidCredentials:
				// TODO: Handle this case.
					break;
				case DomainError.emailInUse:
				// TODO: Handle this case.
					break;
				case DomainError.accessDenied:
				// TODO: Handle this case.
					break;
			}
		} finally {
			_isLoading.value = false;
		}
	}
}