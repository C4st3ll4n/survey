import 'package:faker/faker.dart';
import 'package:meta/meta.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/data/usecases/usecases.dart';
import 'package:survey/domain/entities/entities.dart';
import 'package:survey/domain/helpers/domain_error.dart';
import 'package:survey/domain/usecases/usecases.dart';
import 'package:survey/main/composites/composites.dart';

void main() {
  RemoteLoadSurveysWithLocalFallback sut;
  RemoteLoadSurveys remote;
  LocalLoadSurveys local;
  List<SurveyEntity> remoteSurveys;
  List<SurveyEntity> localSurveys;
  
  List<SurveyEntity> _mockValidRemoteSurveys() => [
        SurveyEntity(
            id: faker.guid.guid(),
            question: faker.randomGenerator.string(50),
            dateTime: faker.date.dateTime(),
            didAnswer: true)
      ];
  
  PostExpectation _mockRemoteCall ()=>when(remote.load());

  void mockRemoteLoad() {
    remoteSurveys = _mockValidRemoteSurveys();
    _mockRemoteCall().thenAnswer((_) async => remoteSurveys);
  }
  
  void mockRemoteError(DomainError error)=> _mockRemoteCall().thenThrow(error);

  List<SurveyEntity> _mockValidLocalSurveys() => [
    SurveyEntity(
        id: faker.guid.guid(),
        question: faker.randomGenerator.string(50),
        dateTime: faker.date.dateTime(),
        didAnswer: true)
  ];

  PostExpectation _mockLocalCall ()=>when(local.load());

  void mockLocalLoad() {
    localSurveys = _mockValidLocalSurveys();
    _mockLocalCall().thenAnswer((_) async => localSurveys);
  }

  void mockLocalError()=> _mockLocalCall().thenThrow(DomainError.unexpected);


  setUp(() {
    remote = RemoteLoadSurveysSpy();
    local = LocalLoadSurveysSpy();
    sut = RemoteLoadSurveysWithLocalFallback(remote: remote, local: local);
    mockRemoteLoad();
    mockLocalLoad();
  });

  test("Should call remote load", () async {
    await sut.load();
    verify(remote.load()).called(1);
  });

  test("Should call local save with remote data", () async {
    await sut.load();
    verify(local.save(remoteSurveys)).called(1);
  });

  test("Should return remote data", () async {
    final result = await sut.load();
    expect(result, remoteSurveys);
  });
  
  test("Should rethrow when remote throws AccessDeniedError", () async {
    mockRemoteError(DomainError.accessDenied);
    final future = sut.load();
    expect(future, throwsA(DomainError.accessDenied));
  });
  
  test("Should call local fetch on remote errro", () async {
    mockRemoteError(DomainError.unexpected);
    
    await sut.load();
    
    verify(local.validate()).called(1);
    verify(local.load()).called(1);
  
  });
  
  test("Should return local surveys", () async {
    mockRemoteError(DomainError.unexpected);
    
    final surveys = await sut.load();
    
    expect(localSurveys, surveys);
  });
  
  test("Should rethrow when local throws ", () async {
    mockRemoteError(DomainError.unexpected);
    mockLocalError();
    final future = sut.load();
    expect(future, throwsA(DomainError.unexpected));
  });
  
}

class RemoteLoadSurveysSpy extends Mock implements RemoteLoadSurveys {}

class LocalLoadSurveysSpy extends Mock implements LocalLoadSurveys {}


