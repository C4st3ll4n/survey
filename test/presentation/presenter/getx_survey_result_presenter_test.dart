import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/domain/entities/entities.dart';
import 'package:survey/domain/helpers/helpers.dart';
import 'package:survey/domain/usecases/usecases.dart';
import 'package:survey/presentation/presenters/presenters.dart';
import 'package:survey/ui/helpers/helpers.dart';
import 'package:survey/ui/pages/pages.dart';
import 'package:test/test.dart';

class LoadSurveyResultSpy extends Mock implements LoadSurveyResult {}
class SaveSurveyResultSpy extends Mock implements SaveSurveyResult {}

void main() {
  SurveyResultPresenter sut;
  LoadSurveyResult loadSurveysResult;
  SaveSurveyResult saveSurveyResult;
  SurveyResultEntity survey;
  String surveyId, answer;
  
  SurveyResultEntity makeSurvey() =>
      SurveyResultEntity(
          surveyId: faker.guid.guid(),
          question: faker.lorem.sentence(),
          answers: [
            SurveyAnswerEntity(
              image: faker.internet.httpUrl(),
                answer: faker.lorem.sentence(),
                percent: faker.randomGenerator.integer(100),
                isCurrentAnswer: faker.randomGenerator.boolean(),),
            SurveyAnswerEntity(
                answer: faker.lorem.sentence(),
                percent: faker.randomGenerator.integer(100),
                isCurrentAnswer: faker.randomGenerator.boolean()),
          ],);

  PostExpectation _mockLoadSurveysCall() => when(
    loadSurveysResult.loadBySurvey(surveyId: anyNamed("surveyId")),
      );

  void mockLoadSurveyResult(SurveyResultEntity data) {
    survey = data;
    _mockLoadSurveysCall().thenAnswer((_) async => survey);
  }

  void mockErrorLoadSurveys(DomainError error) =>
      _mockLoadSurveysCall().thenThrow(error);

  setUp(() {
    surveyId = faker.guid.guid();
    answer = faker.lorem.sentence();
    loadSurveysResult = LoadSurveyResultSpy();
    saveSurveyResult = SaveSurveyResultSpy();
    sut = GetXSurveyResultPresenter(loadSurveyResult: loadSurveysResult,
    surveyId: surveyId, saveSurveyResult: saveSurveyResult);
    mockLoadSurveyResult(makeSurvey());
  });

  group("Load", (){
  
    test("Should call loadBySurvey on LoadData", () async {
      await sut.loadData();
    
      verify(loadSurveysResult.loadBySurvey(surveyId: surveyId)).called(1);
    });
  
    test("Should emits correct evens on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    
      sut.surveyResultStream.listen(
        expectAsync1(
              (surveyResult) {
            expect(
                surveyResult,
                SurveyResultViewModel.fromEntity(survey)
            );
          },
        ),
      );
    
      await sut.loadData();
    });
  
    test("Should emits correct evens on failure", () async {
      mockErrorLoadSurveys(DomainError.unexpected);
    
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      sut.surveyResultStream.listen(
        null,
        onError: expectAsync1(
              (error) {
            expect(error, UIError.unexpected.description);
          },
        ),
      );
    
      await sut.loadData();
    });
  
  
    test("Should emits correct events on accessDenied", () async {
      mockErrorLoadSurveys(DomainError.accessDenied);
    
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.isSessionExpiredStream, emits(true));
    
      await sut.loadData();
    });
  
  });

  group("Save", (){
  
    test("Should call save on SaveSurveyResult", () async {
      await sut.save(answer: answer);
    
      verify(saveSurveyResult.save(answer: answer)).called(1);
    });
    
    
  
  });
  
  
  
}
