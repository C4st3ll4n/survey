import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/data/cache/cache.dart';
import 'package:survey/data/models/models.dart';
import 'package:survey/data/usecases/usecases.dart';
import 'package:survey/domain/entities/entities.dart';
import 'package:survey/domain/helpers/domain_error.dart';

void main() {
  group("load", () {
    LocalLoadSurveyResult sut;
    Map listData;
    CacheStorage cacheStorageSpy;
    String surveyId;
    Map mockValidData() => {
    "surveyId": faker.guid.guid(),
      "question":faker.lorem.sentence(),
      "answers":[
        {
          "image":faker.internet.httpUrl(),
          "answer":faker.lorem.sentence(),
          'isCurrentAccountAnswer':"true",
          'percent':"40"
        },
        {
          "answer":faker.lorem.sentence(),
          'isCurrentAccountAnswer':"false",
          'percent':"60"
        },
      ]
  };
    
    PostExpectation _mockFCSCall() => when(cacheStorageSpy.fetch(any));
    
    void _mockFCSSuccess(Map data) async {
      listData = data;
      _mockFCSCall().thenAnswer((_) async => data);
    }
    
    void _mockFCSError() async {
      _mockFCSCall().thenThrow(Exception());
    }
    
    setUp(
          () {
            surveyId = faker.guid.guid();
        cacheStorageSpy = CacheStorageSpy();
        sut = LocalLoadSurveyResult(cacheStorage: cacheStorageSpy);
        
        _mockFCSSuccess(mockValidData());
      },
    );
    
    test("Should call FetchCacheStorage with correct key", () async {
      await sut.loadBySurvey(surveyId: surveyId);
      verify(cacheStorageSpy.fetch("survey_result/$surveyId")).called(1);
    });
    
    test(
      "Should return survey result on success",
          () async {
        final survey = await sut.loadBySurvey(surveyId: surveyId);
        expect(
          survey,
          LocalSurveyResultModel.fromJson(listData).toEntity(),
          );
      },
    );
    
    test(
      "Should throw UnexpectedError if cach is empty",
          () async {
        _mockFCSSuccess({});
        final future = sut.loadBySurvey(surveyId: surveyId);
        expect(future, throwsA(DomainError.unexpected));
      },
    );
    
    test(
      "Should throw UnexpectedError if cach is null",
          () async {
        _mockFCSSuccess(null);
        final future = sut.loadBySurvey(surveyId: surveyId);
        expect(future, throwsA(DomainError.unexpected));
      },
    );
    
    test(
      "Should throw UnexpectedError if cach is invalid",
          () async {
        _mockFCSSuccess({});
        var future = sut.loadBySurvey(surveyId: surveyId);
        expect(future, throwsA(DomainError.unexpected));
        ///Incomplete data
        _mockFCSSuccess(
          {
            "didAnswer": "true",
            "date": "2020-07-20T00:00:00Z",
          },
        );
        future = sut.loadBySurvey(surveyId: surveyId);
        expect(future, throwsA(DomainError.unexpected));
      },
    );
    
    test(
      "Should throw UnexpectedError if loadCacheSurveys fails",
          () async {
        _mockFCSError();
        final future = sut.loadBySurvey(surveyId: surveyId);
        expect(future, throwsA(DomainError.unexpected));
      },
    );
  });

}

class CacheStorageSpy extends Mock implements CacheStorage {}
