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
  StreamController<List<SurveyViewModel>> loadSurveysController;
  
  void _initStream(){
    isLoadingController = StreamController();
    loadSurveysController = StreamController();
  }
  void _mockStream(){
    when(presenter.isLoadingStream).thenAnswer(
            (_) => isLoadingController.stream);
    
    when(presenter.loadSurveysStream).thenAnswer(
            (_) => loadSurveysController.stream);
  }
  void _closeStream(){
    loadSurveysController.close();
    isLoadingController.close();
  }
  
  tearDown((){
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
    },
  );
}

class SurveysPresenterSpy extends Mock implements SurveysPresenter {}
