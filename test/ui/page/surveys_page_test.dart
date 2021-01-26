import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/ui/pages/pages.dart';

void main() {
  SurveysPresenter presenter;
  Future loadPage(WidgetTester tester) async {
    presenter = SurveysPresenterSpy();
    final surveysPage = GetMaterialApp(
      initialRoute: "/surveys",
      getPages: [
        GetPage(name: "/surveys", page: () => SurveysPage(presenter: presenter,)),
      ],
    );

    await tester.pumpWidget(surveysPage);
  }

  testWidgets(
      "Should call LoadSurveys on page load", (WidgetTester tester) async {
        await loadPage(tester);
        
        verify(presenter.loadData()).called(1);
  });
}

class SurveysPresenterSpy extends Mock implements SurveysPresenter{}
