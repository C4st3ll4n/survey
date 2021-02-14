import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/data/usecases/usecases.dart';
import 'package:survey/domain/entities/entities.dart';
import 'package:survey/main/composites/composites.dart';
import 'package:test/test.dart';

class RemoteSpy extends Mock implements RemoteLoadSurveyResult {}

class LocalSpy extends Mock implements LocalLoadSurveyResult {}

void main() {
  String surveyId;
  RemoteLoadSurveyResultWithLocalFallback sut;
  RemoteLoadSurveyResult remoteSpy;
  LocalLoadSurveyResult localSpy;
  SurveyResultEntity mockedSurvey;

  PostExpectation _mockLocalCall() => when(
        localSpy.loadBySurvey(
          surveyId: anyNamed("surveyId"),
        ),
      );

  PostExpectation _mockRemoteCall() => when(
        remoteSpy.loadBySurvey(
          surveyId: anyNamed("surveyId"),
        ),
      );

  void mockRemoteSuccess({SurveyResultEntity entity}) =>
      _mockRemoteCall().thenAnswer((_) async => entity);

  SurveyResultEntity mockSurveyResult() => SurveyResultEntity(
        surveyId: faker.guid.guid(),
        question: faker.lorem.sentence(),
        answers: [
          SurveyAnswerEntity(
              answer: faker.lorem.sentence(),
              percent: faker.randomGenerator.integer(100),
              isCurrentAnswer: faker.randomGenerator.boolean()),
        ],
      );

  setUp(() {
    remoteSpy = RemoteSpy();
    localSpy = LocalSpy();
    surveyId = faker.guid.guid();

    sut = RemoteLoadSurveyResultWithLocalFallback(
        remote: remoteSpy, local: localSpy);

    mockedSurvey = mockSurveyResult();
    mockRemoteSuccess(entity: mockedSurvey);
  });
  test("Should call remote loadBySurvey", () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(remoteSpy.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test("Should call local save with remote data", () async {
    final resultEntity = await sut.loadBySurvey(surveyId: surveyId);
    verify(localSpy.save(surveyId, resultEntity)).called(1);
  });

  test("Should return remote data", () async {
    final resultEntity = await sut.loadBySurvey(surveyId: surveyId);
    expect(resultEntity, mockedSurvey);
  });
}
