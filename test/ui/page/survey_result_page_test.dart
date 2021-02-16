import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:image_test_utils/image_test_utils.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/ui/helpers/errors/errors.dart';
import 'package:survey/ui/pages/pages.dart';
import 'package:survey/ui/pages/survey_result/survey_result.dart';

class SurveyResultPresenterSpy extends Mock implements SurveyResultPresenter {}

void main() {
  SurveyResultPresenter presenter;
  StreamController<bool> isSessionExpiredController;
  StreamController<bool> isLoadingController;
  StreamController<SurveyResultViewModel> loadSurveyResultController;

  SurveyResultViewModel makeSurveyResult() =>
      SurveyResultViewModel(surveyId: "any_id", question: "Questão", answers: [
        SurveyAnswerViewModel(
            image: "img 0",
            answer: "answer 0",
            isCurrentAnswer: true,
            percent: "60%"),
        SurveyAnswerViewModel(
            answer: "answer 1", isCurrentAnswer: false, percent: "70%"),
      ]);

  void _initStream() {
    isLoadingController = StreamController();
    loadSurveyResultController = StreamController();
    isSessionExpiredController = StreamController();
  }

  void _mockStream() {
    when(presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);

    when(presenter.surveyResultStream)
        .thenAnswer((_) => loadSurveyResultController.stream);

    when(presenter.isSessionExpiredStream)
        .thenAnswer((_) => isSessionExpiredController.stream);
  }

  void _closeStream() {
    loadSurveyResultController.close();
    isLoadingController.close();
    isSessionExpiredController.close();
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
        GetPage(
          name: "/login",
          page: () => Scaffold(
            body: Text("Fake Login"),
          ),
        ),
      ],
    );

    await provideMockedNetworkImages(() async {
      await tester.pumpWidget(surveyResultPage);
    });
  }

  testWidgets("Should call LoadSurveyResult on page load",
      (WidgetTester tester) async {
    await loadPage(tester);
    verify(presenter.loadData()).called(1);
  });
  testWidgets("Should handle loading", (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    isLoadingController.add(false);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);

    isLoadingController.add(true);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    isLoadingController.add(null);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets(
    "Shoud present error message if load surveys fails",
    (tester) async {
      await loadPage(tester);
      loadSurveyResultController.addError(UIError.unexpected.description);
      await tester.pump();

      expect(find.text(UIError.unexpected.description), findsOneWidget);
      expect(find.text("Recarregar"), findsOneWidget);
      expect(find.text("Questão"), findsNothing);
    },
  );

  testWidgets(
    "Shoud call loadSurvey refresh clicked",
    (tester) async {
      await loadPage(tester);
      loadSurveyResultController.addError(UIError.unexpected.description);
      await tester.pump();

      expect(find.text(UIError.unexpected.description), findsOneWidget);
      final button = find.text("Recarregar");
      await tester.ensureVisible(button);
      await tester.tap(button);

      verify(presenter.loadData()).called(2);
    },
  );

  testWidgets(
    "Shoud present valid data when surveyResultStream succeeds",
    (tester) async {
      await loadPage(tester);
      loadSurveyResultController.add(makeSurveyResult());

      await provideMockedNetworkImages(() async {
        await tester.pump();
      });

      expect(find.text(UIError.unexpected.description), findsNothing);
      expect(find.text("Recarregar"), findsNothing);

      expect(find.text("Questão"), findsOneWidget);
      expect(find.text("answer 0"), findsOneWidget);
      expect(find.text("answer 1"), findsOneWidget);
      expect(find.text("60%"), findsOneWidget);
      expect(find.text("70%"), findsOneWidget);

      expect(find.byType(ActiveIcon), findsOneWidget);
      expect(find.byType(DisableIcon), findsOneWidget);
      final img =
          tester.widget<Image>(find.byType(Image)).image as NetworkImage;
      expect(img.url, "img 0");
    },
  );

  testWidgets(
    "Shoud logout",
    (tester) async {
      await loadPage(tester);
      isSessionExpiredController.add(true);
      await tester.pumpAndSettle();

      expect(Get.currentRoute, "/login");
      expect(find.text('Fake Login'), findsOneWidget);
    },
  );

  testWidgets("Shouldnt logout", (tester) async {
    await loadPage(tester);

    isSessionExpiredController.add(false);
    await tester.pump();
    expect(Get.currentRoute, "/survey_result/any_survey_id");

    isSessionExpiredController.add(null);
    await tester.pump();
    expect(Get.currentRoute, "/survey_result/any_survey_id");
  });


  testWidgets(
    "Shoud call save on list item clicked",
        (tester) async {
      await loadPage(tester);
    
      loadSurveyResultController.add(makeSurveyResult());
      await provideMockedNetworkImages(()async{
        await tester.pump();
      });
    
      await tester.tap(find.text("answer 0"));
    
      verify(presenter.save(answer:"answer 0")).called(1);
    },
  );
  
}
