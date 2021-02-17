import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/ui/helpers/helpers.dart';
import 'package:survey/ui/pages/pages.dart';

void main() {
  SurveysPresenter presenter;

  StreamController<bool> isLoadingController;
  StreamController<bool> isSessionExpiredController;
  StreamController<String> navigateToController;
  StreamController<List<SurveyViewModel>> loadSurveysController;

  void _initStream() {
    isLoadingController = StreamController();
    navigateToController = StreamController();
    loadSurveysController = StreamController();
    isSessionExpiredController = StreamController();
  }

  void _mockStream() {
    when(presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);

    when(presenter.isSessionExpiredStream)
        .thenAnswer((_) => isSessionExpiredController.stream);

    when(presenter.surveysStream)
        .thenAnswer((_) => loadSurveysController.stream);

    when(presenter.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);
  }

  void _closeStream() {
    loadSurveysController.close();
    isLoadingController.close();
    navigateToController.close();
    isSessionExpiredController.close();
  }

  tearDown(() {
    _closeStream();
  });

  Future loadPage(WidgetTester tester) async {
    presenter = SurveysPresenterSpy();
    _initStream();
    _mockStream();
    final routeObserver = Get.put<RouteObserver>(RouteObserver<PageRoute>());

    final surveysPage = GetMaterialApp(
      initialRoute: "/surveys",
      navigatorObservers: [
        routeObserver,
      ],
      getPages: [
        GetPage(
            name: "/surveys",
            page: () => SurveysPage(
                  presenter: presenter,
                )),
        GetPage(
          name: "/fake_page",
          page: () => Scaffold(
            appBar: AppBar(
              title: Text("Fake tittle"),
            ),
            body: Text("Fake Page"),
          ),
        ),
        GetPage(
          name: "/login",
          page: () => Scaffold(
            body: Text("Fake Login"),
          ),
        ),
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

  testWidgets(
    "Should go to SurveyResult page on click",
    (tester) async {
      await loadPage(tester);

      loadSurveysController.add(makeSurveys());
      await tester.pump();

      await tester.tap(find.text("Question 1"));
      await tester.pump();

      verify(presenter.goToSurveyResult('1')).called(1);
    },
  );

  testWidgets(
    "Shoud change page",
    (tester) async {
      await loadPage(tester);
      navigateToController.add("/fake_page");
      await tester.pumpAndSettle();

      expect(Get.currentRoute, "/fake_page");
      expect(find.text('Fake Page'), findsOneWidget);
    },
  );

  testWidgets("Shouldnt change page", (tester) async {
    await loadPage(tester);

    navigateToController.add("");
    await tester.pump();
    expect(Get.currentRoute, "/surveys");

    navigateToController.add(null);
    await tester.pump();
    expect(Get.currentRoute, "/surveys");
  });

  testWidgets(
    "Shoud change page",
    (tester) async {
      await loadPage(tester);
      navigateToController.add("/fake_page");
      await tester.pumpAndSettle();

      expect(Get.currentRoute, "/fake_page");
      expect(find.text('Fake Page'), findsOneWidget);
    },
  );

  testWidgets("Shouldnt change page", (tester) async {
    await loadPage(tester);

    navigateToController.add("");
    await tester.pump();
    expect(Get.currentRoute, "/surveys");

    navigateToController.add(null);
    await tester.pump();
    expect(Get.currentRoute, "/surveys");
  });

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
    expect(Get.currentRoute, "/surveys");

    isSessionExpiredController.add(null);
    await tester.pump();
    expect(Get.currentRoute, "/surveys");
  });

  testWidgets("Should call LoadSurveys on page reload",
      (WidgetTester tester) async {
    await loadPage(tester);
    navigateToController.add("/fake_page");
    await tester.pumpAndSettle();
    await tester.pageBack();
    verify(presenter.loadData()).called(2);
  });
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
