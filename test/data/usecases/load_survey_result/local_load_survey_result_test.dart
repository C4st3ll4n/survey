import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/data/cache/cache.dart';
import 'package:survey/data/usecases/usecases.dart';
import 'package:survey/domain/entities/entities.dart';
import 'package:survey/domain/helpers/domain_error.dart';

void main() {
  group("load", () {
    LocalLoadSurveys sut;
    List<Map> listData;
    CacheStorage cacheStorageSpy;
    List<Map> mockValidData() => [
          {
            "id": faker.guid.guid(),
            "question": faker.randomGenerator.string(50),
            "didAnswer": "true",
            "date": "2020-07-20T00:00:00Z"
          },
          {
            "id": faker.guid.guid(),
            "question": faker.randomGenerator.string(50),
            "didAnswer": "false",
            "date": "2020-12-20T00:00:00Z",
          },
        ];

    PostExpectation _mockFCSCall() => when(cacheStorageSpy.fetch(any));

    void _mockFCSSuccess(List<Map> data) async {
      listData = data;
      _mockFCSCall().thenAnswer((_) async => data);
    }

    void _mockFCSError() async {
      _mockFCSCall().thenThrow(Exception());
    }

    setUp(
      () {
        cacheStorageSpy = CacheStorageSpy();
        sut = LocalLoadSurveys(cacheStorage: cacheStorageSpy);

        _mockFCSSuccess(mockValidData());
      },
    );

    test("Should call FetchCacheStorage with correct key", () async {
      await sut.load();
      verify(cacheStorageSpy.fetch("surveys")).called(1);
    });

    test(
      "Should return list of survey on success",
      () async {
        final surveys = await sut.load();
        expect(
          surveys,
          [
            SurveyEntity(
              id: listData[0]['id'],
              question: listData[0]['question'],
              dateTime: DateTime.utc(2020, 07, 20),
              didAnswer: true,
            ),
            SurveyEntity(
              id: listData[1]['id'],
              question: listData[1]['question'],
              dateTime: DateTime.utc(2020, 12, 20),
              didAnswer: false,
            ),
          ],
        );
      },
    );

    test(
      "Should throw UnexpectedError if cach is empty",
      () async {
        _mockFCSSuccess([]);
        final future = sut.load();
        expect(future, throwsA(DomainError.unexpected));
      },
    );

    test(
      "Should throw UnexpectedError if cach is null",
      () async {
        _mockFCSSuccess(null);
        final future = sut.load();
        expect(future, throwsA(DomainError.unexpected));
      },
    );

    test(
      "Should throw UnexpectedError if cach is invalid",
      () async {
        _mockFCSSuccess([
          {
            "id": faker.guid.guid(),
            "question": faker.randomGenerator.string(50),
            "didAnswer": "true",
            "date": "invalid date"
          },
        ]);
        var future = sut.load();
        expect(future, throwsA(DomainError.unexpected));
        //Incomplete data
        _mockFCSSuccess([
          {
            "didAnswer": "true",
            "date": "2020-07-20T00:00:00Z",
          },
        ]);
        future = sut.load();
        expect(future, throwsA(DomainError.unexpected));
      },
    );

    test(
      "Should throw UnexpectedError if loadCacheSurveys fails",
      () async {
        _mockFCSError();
        final future = sut.load();
        expect(future, throwsA(DomainError.unexpected));
      },
    );
  });

  group("validate", () {
    LocalLoadSurveys sut;
    List<Map> listData;
    CacheStorage cacheStorageSpy;
    List<Map> mockValidData() => [
          {
            "id": faker.guid.guid(),
            "question": faker.randomGenerator.string(50),
            "didAnswer": "true",
            "date": "2020-07-20T00:00:00Z"
          },
          {
            "id": faker.guid.guid(),
            "question": faker.randomGenerator.string(50),
            "didAnswer": "false",
            "date": "2020-12-20T00:00:00Z",
          },
        ];

    PostExpectation _mockFCSCall() => when(cacheStorageSpy.fetch(any));

    void _mockFCSSuccess(List<Map> data) async {
      listData = data;
      _mockFCSCall().thenAnswer((_) async => data);
    }

    void _mockFCSError() async {
      _mockFCSCall().thenThrow(Exception());
    }

    setUp(
      () {
        cacheStorageSpy = CacheStorageSpy();
        sut = LocalLoadSurveys(cacheStorage: cacheStorageSpy);

        _mockFCSSuccess(mockValidData());
      },
    );

    test("Should call CacheStorage with correct key", () async {
      await sut.validate();
      verify(cacheStorageSpy.fetch('surveys')).called(1);
    });

    test("Should delete cache if its invalid", () async {
      _mockFCSSuccess([
        {
          "id": faker.guid.guid(),
          "question": faker.randomGenerator.string(50),
          "didAnswer": "invalid bool",
          "date": "invalid data"
        },
      ]);
      await sut.validate();
      verify(cacheStorageSpy.delete("surveys")).called(1);
    });

    test("Should delete cache if its invalid", () async {
      _mockFCSSuccess([
        {"didAnswer": "true", "date": "2020-12-20T00:00:00Z"},
      ]);
      await sut.validate();
      verify(cacheStorageSpy.delete("surveys")).called(1);
    });

    test("Should delete cache if its invalid", () async {
      _mockFCSError();
      await sut.validate();
      verify(cacheStorageSpy.delete("surveys")).called(1);
    });
  });

  group("save", () {
    LocalLoadSurveys sut;
    CacheStorage cacheStorageSpy;
    List<SurveyEntity> surveys;
    List<SurveyEntity> mockSurveys() => [
          SurveyEntity(
              id: faker.guid.guid(),
              question: faker.randomGenerator.string(50),
              dateTime: DateTime.utc(2020, 2, 2),
              didAnswer: true),
          SurveyEntity(
              id: faker.guid.guid(),
              question: faker.randomGenerator.string(50),
              dateTime: DateTime.utc(2018, 6, 3),
              didAnswer: false),
        ];
    PostExpectation _mockFCSCall() => when(cacheStorageSpy.save(key: anyNamed("key"), value: anyNamed("value")));
    void _mockFCSError() async {
      _mockFCSCall().thenThrow(Exception());
    }

    setUp(
      () {
        cacheStorageSpy = CacheStorageSpy();
        sut = LocalLoadSurveys(cacheStorage: cacheStorageSpy);

        surveys = mockSurveys();
      },
    );

    test("Should call CacheStorage with correct values", () async {
      final list = [
        {
          "id": surveys.elementAt(0).id,
          "question": surveys.elementAt(0).question,
          "date": "2020-02-02T00:00:00.000Z",
          "didAnswer": "true",
        },
        {
          "id": surveys.elementAt(1).id,
          "question": surveys.elementAt(1).question,
          "date": "2018-06-03T00:00:00.000Z",
          "didAnswer": "false",
        }
      ];
      await sut.save(surveys);
      verify(cacheStorageSpy.save(key: 'surveys', value: list)).called(1);
    });
    
    test("Should throw UnexpectedError if save throws", () async {
      _mockFCSError();
    
      final future = sut.save(surveys);
      
      expect(future, throwsA(DomainError.unexpected));
    });
  });
}

class CacheStorageSpy extends Mock implements CacheStorage {}
