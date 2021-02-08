import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:image_test_utils/image_test_utils.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/domain/entities/entities.dart';
import 'package:survey/ui/pages/pages.dart';

class SurveyResultPresenterSpy extends Mock implements SurveyResultPresenter {}

void main() {
  SurveyResultPresenter presenter;
  StreamController<bool> isLoadingController;
  StreamController<SurveyResultEntity> loadSurveyResultController;

  void _initStream() {
    isLoadingController = StreamController();
    loadSurveyResultController = StreamController();
  }

  void _mockStream() {
    /* when(presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);

    when(presenter.surveysStream)
        .thenAnswer((_) => loadSurveyResultController.stream);*/
  }

  void _closeStream() {
    loadSurveyResultController.close();
    isLoadingController.close();
  }

  tearDown(() {
    _closeStream();
  });

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveyResultPresenterSpy();
    _initStream();
    _mockStream();

    final surveyResultPage = GetMaterialApp(
      initialRoute: "/survey_result/any_survey_id",
      getPages: [
        GetPage(
          name: "/survey_result/:survey_id",
          page: () => SurveyResultPage(presenter: presenter),
        ),
      ],
    );

    provideMockedNetworkImages(() async {
      await tester.pumpWidget(surveyResultPage);
    });
  }

  testWidgets("Should call LoadSurveyResult on page load",
      (WidgetTester tester) async {
    await loadPage(tester);
    verify(presenter.loadData()).called(1);
  });
}
