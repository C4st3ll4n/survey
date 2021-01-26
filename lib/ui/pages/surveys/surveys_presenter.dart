abstract class SurveysPresenter{
	Future<void> loadData();
	Stream<bool> isLoadingStream;
}