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
  });
}

class CacheStorageSpy extends Mock implements CacheStorage {}
