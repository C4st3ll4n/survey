import 'package:faker/faker.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/domain/entities/entities.dart';
import 'package:survey/domain/helpers/domain_error.dart';
import 'package:survey/domain/usecases/usecases.dart';
import 'package:survey/ui/pages/pages.dart';

class LoadSurveysSpy extends Mock implements LoadSurveys {}

void main() {
  SurveysPresenter sut;
  LoadSurveys loadSurveys;

  List<SurveyEntity> makeSurveys() => [
        SurveyEntity(
            id: "1",
            question: "Question 1",
            dateTime: faker.date.dateTime(),
            didAnswer: true),
        SurveyEntity(
            id: "2",
            question: "Question 2",
            dateTime: faker.date.dateTime(),
            didAnswer: false),
      ];

  PostExpectation _mockLoadSurveysCall() => when(
        loadSurveys.load(),
      );

  void mockLoadsurvey() =>
      _mockLoadSurveysCall().thenAnswer((_) async => makeSurveys());

  test("Should call loadSurveys on LoadData", () async {
    await sut.loadData();
    verify(loadSurveys.load()).called(1);
  });

  setUp(() {
    loadSurveys = LoadSurveysSpy();
    sut = GetXSurveysPresenter(loadSurveys: loadSurveys);
    mockLoadsurvey();
  });
}

