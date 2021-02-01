import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/ui/helpers/helpers.dart';
import 'package:survey/ui/pages/pages.dart';

void main() {
  SurveysPresenter presenter;

  StreamController<bool> isLoadingController;
  StreamController<List<SurveyViewModel>> loadSurveysController;

  void _initStream() {
    isLoadingController = StreamController();
    loadSurveysController = StreamController();
  }

  void _mockStream() {
    when(presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);

    when(presenter.surveysStream)
        .thenAnswer((_) => loadSurveysController.stream);
  }

  void _closeStream() {
    loadSurveysController.close();
    isLoadingController.close();
  }

  tearDown(() {
    _closeStream();
  });

  Future loadPage(WidgetTester tester) async {
    presenter = SurveysPresenterSpy();
    _initStream();
    _mockStream();
    final surveysPage = GetMaterialApp(
      initialRoute: "/surveys",
      getPages: [
        GetPage(
            name: "/surveys",
            page: () => SurveysPage(
                  presenter: presenter,
                )),
      ],
    );

    await tester.pumpWidget(surveysPage);
  }

  testWidgets("Should call LoadSurveys on page load",
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
      loadSurveysController.addError(UIError.unexpected.description);
      await tester.pump();

      expect(find.text(UIError.unexpected.description), findsOneWidget);
      expect(find.text("Recarregar"), findsOneWidget);
      expect(find.text("Question 1"), findsNothing);
    },
  );

  testWidgets(
    "Shoud present list load surveys succeeds",
    (tester) async {
      await loadPage(tester);
      loadSurveysController.add(makeSurveys());
      await tester.pump();

      expect(find.text(UIError.unexpected.description), findsNothing);
      expect(find.text("Recarregar"), findsNothing);
      expect(find.text("Question 1"), findsWidgets);
      expect(find.text("Question 2"), findsWidgets);

      expect(find.text("26/01/2020"), findsWidgets);
      expect(find.text("25/02/2020"), findsWidgets);
    },
  );

  testWidgets(
    "Shoud call loadSurvey refresh clicked",
    (tester) async {
      await loadPage(tester);
      loadSurveysController.addError(UIError.unexpected.description);
      await tester.pump();

      expect(find.text(UIError.unexpected.description), findsOneWidget);
      final button = find.text("Recarregar");
      await tester.ensureVisible(button);
      await tester.tap(button);
      
      verify(presenter.loadData()).called(2);
    },
  );
}

List<SurveyViewModel> makeSurveys() => [
      SurveyViewModel(
          id: "1",
          question: "Question 1",
          formatedDate: "26/01/2020",
          didAnswer: true),
      SurveyViewModel(
          id: "2",
          question: "Question 2",
          formatedDate: "25/02/2020",
          didAnswer: false),
    ];

class SurveysPresenterSpy extends Mock implements SurveysPresenter {}
