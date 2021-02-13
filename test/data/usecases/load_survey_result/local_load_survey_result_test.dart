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
          "question": faker.lorem.sentence(),
          "answers": [
            {
              "image": faker.internet.httpUrl(),
              "answer": faker.lorem.sentence(),
              'isCurrentAccountAnswer': "true",
              'percent': "40"
            },
            {
              "answer": faker.lorem.sentence(),
              'isCurrentAccountAnswer': "false",
              'percent': "60"
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

  group("validate", () {
    LocalLoadSurveyResult sut;
    CacheStorage cacheStorageSpy;
    String surveyId;
    Map mockValidData() => {
          "surveyId": faker.guid.guid(),
          "question": faker.lorem.sentence(),
          "answers": [
            {
              "image": faker.internet.httpUrl(),
              "answer": faker.lorem.sentence(),
              'isCurrentAccountAnswer': "true",
              'percent': "40"
            },
            {
              "answer": faker.lorem.sentence(),
              'isCurrentAccountAnswer': "false",
              'percent': "60"
            },
          ]
        };

    PostExpectation _mockFCSCall() => when(cacheStorageSpy.fetch(any));

    void _mockFCSSuccess(Map data) async {
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

    test("Should call CacheStorage with correct key", () async {
      await sut.validate(surveyId);
      verify(cacheStorageSpy.fetch('survey_result/$surveyId')).called(1);
    });

    test("Should delete cache if its invalid", () async {
      _mockFCSSuccess(
        {
          "surveyId": 000000,
          "question": faker.lorem.sentence(),
          "answers": [
            {
              "image": faker.internet.httpUrl(),
              "answer": faker.lorem.sentence(),
              'isCurrentAccountAnswer': "true",
              'percent': "40"
            },
            {
              "answer": faker.lorem.sentence(),
              'isCurrentAccountAnswer': "false",
              'percent': "invalid int"
            },
          ]
        },
      );
      await sut.validate(surveyId);
      verify(cacheStorageSpy.delete("survey_result/$surveyId")).called(1);
    });

    test("Should delete cache if its incomplete", () async {
      _mockFCSSuccess(
        {
          "question": faker.lorem.sentence(),
          "answers": [
            {
              "image": faker.internet.httpUrl(),
              "answer": faker.lorem.sentence(),
              'isCurrentAccountAnswer': "true",
              'percent': "40"
            },
            {
              "answer": faker.lorem.sentence(),
              'isCurrentAccountAnswer': "false",
              'percent': "invalid int"
            },
          ]
        },
      );
      await sut.validate(surveyId);
      verify(cacheStorageSpy.delete("survey_result/$surveyId")).called(1);
    });

    test("Should delete cache if its fails", () async {
      _mockFCSError();
      await sut.validate(surveyId);
      verify(cacheStorageSpy.delete("survey_result/$surveyId")).called(1);
    });
  });

  group("save", () {
    LocalLoadSurveyResult sut;
    SurveyResultEntity resultEntity;
    CacheStorage cacheStorageSpy;

    SurveyResultEntity mockValidData() => SurveyResultEntity(
            surveyId: faker.guid.guid(),
            question: faker.lorem.sentence(),
            answers: [
              SurveyAnswerEntity(
                  image: faker.internet.httpUrl(),
                  answer: faker.lorem.sentence(),
                  percent: 40,
                  isCurrentAnswer: true),
              SurveyAnswerEntity(
                  answer: faker.lorem.sentence(),
                  percent: 60,
                  isCurrentAnswer: false),
            ]);

    PostExpectation _mockFCSCall() => when(
          cacheStorageSpy.save(
            key: anyNamed("key"),
            value: anyNamed("value"),
          ),
        );

    void _mockFCSError() async {
      _mockFCSCall().thenThrow(Exception());
    }

    setUp(
      () {
        cacheStorageSpy = CacheStorageSpy();
        sut = LocalLoadSurveyResult(cacheStorage: cacheStorageSpy);
        resultEntity = mockValidData();
      },
    );

    test("Should call CacheStorage with correct values", () async {
      final list = {
        "surveyId": resultEntity.surveyId,
        "question": resultEntity.question,
        "answers": [
          {
            "image": resultEntity.answers[0].image,
            "answer": resultEntity.answers[0].answer,
            'isCurrentAccountAnswer': "true",
            'percent': "40"
          },
          {
            "image":null,
            "answer": resultEntity.answers[1].answer,
            'isCurrentAccountAnswer': "false",
            'percent': "60"
          },
        ]
      };

      await sut.save(resultEntity.surveyId, resultEntity);
      verify(cacheStorageSpy.save(
              key: 'survey_result/${resultEntity.surveyId}', value: list))
          .called(1);
    });

    test("Should throw UnexpectedError if save throws", () async {
      _mockFCSError();

      final future = sut.save(resultEntity.surveyId, resultEntity);

      expect(future, throwsA(DomainError.unexpected));
    });
  });
}

class CacheStorageSpy extends Mock implements CacheStorage {}
