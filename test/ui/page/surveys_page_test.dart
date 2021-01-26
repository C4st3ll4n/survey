import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/ui/pages/pages.dart';

void main() {
  SurveysPresenter presenter;
  StreamController<bool> isLoadingController;
  
  
  void _initStream(){
    isLoadingController = StreamController();
  }
  void _mockStream(){
    when(presenter.isLoadingStream).thenAnswer((realInvocation) => isLoadingController.stream);
  }
  void _closeStream(){
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
}

class SurveysPresenterSpy extends Mock implements SurveysPresenter {}
