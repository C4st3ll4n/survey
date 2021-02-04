import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/domain/entities/entities.dart';
import 'package:survey/domain/helpers/helpers.dart';
import 'package:survey/domain/usecases/usecases.dart';
import 'package:survey/presentation/presenters/presenters.dart';
import 'package:survey/ui/helpers/helpers.dart';
import 'package:survey/ui/pages/pages.dart';

class LoadSurveysSpy extends Mock implements LoadSurveys {}

void main() {
  SurveysPresenter sut;
  LoadSurveys loadSurveys;
  List<SurveyEntity> surveys;

  List<SurveyEntity> makeSurveys() => [
        SurveyEntity(
            id: "1",
            question: "Question 1",
            dateTime: DateTime(2020, 2, 20),
            didAnswer: true),
        SurveyEntity(
            id: "2",
            question: "Question 2",
            dateTime: DateTime(2019, 12, 20),
            didAnswer: false),
      ];

  PostExpectation _mockLoadSurveysCall() => when(
        loadSurveys.load(),
      );

  void mockLoadsurvey(List<SurveyEntity> data) {
    surveys = data;
    _mockLoadSurveysCall().thenAnswer((_) async => surveys);
  }

  void mockErrorLoadSurveys(DomainError error) =>
      _mockLoadSurveysCall().thenThrow(error);

  setUp(() {
    loadSurveys = LoadSurveysSpy();
    sut = GetXSurveysPresenter(loadSurveys: loadSurveys);
    mockLoadsurvey(makeSurveys());
  });

  test("Should call loadSurveys on LoadData", () async {
    await sut.loadData();
    verify(loadSurveys.load()).called(1);
  });

  test("Should emits correct evens on success", () async {
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    sut.surveysStream.listen(
      expectAsync1(
        (surveysList) {
          expect(
            surveysList,
            [
              SurveyViewModel(
                  id: surveys[0].id,
                  question: surveys[0].question,
                  formatedDate: "20 Feb 2020",
                  didAnswer: surveys[0].didAnswer),
              SurveyViewModel(
                  id: surveys[1].id,
                  question: surveys[1].question,
                  formatedDate: "20 Dec 2019",
                  didAnswer: surveys[1].didAnswer),
            ],
          );
        },
      ),
    );

    await sut.loadData();
  });

  test("Should emits correct evens on failure", () async {
    mockErrorLoadSurveys(DomainError.unexpected);
    
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.surveysStream.listen(
      null,
      onError: expectAsync1(
        (error) {
          expect(error, UIError.unexpected.description);
        },
      ),
    );

    await sut.loadData();
  });
}
