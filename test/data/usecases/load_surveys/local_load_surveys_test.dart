import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/data/cache/cache.dart';
import 'package:survey/data/usecases/load_surveys/load_surveys.dart';
import 'package:survey/domain/entities/entities.dart';
import 'package:survey/domain/helpers/domain_error.dart';

void main() {
  LocalLoadSurveys sut;
  List<Map> listData;
  FetchCacheStorage fetchCacheStorageSpy;

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

  PostExpectation _mockFCSCall() => when(fetchCacheStorageSpy.fetch(any));
  void _mockFCSSuccess(List<Map> data) async {
    listData = data;
    _mockFCSCall().thenAnswer((_) async => data);
  }

  setUp(
    () {
      fetchCacheStorageSpy = FetchCacheStorageSpy();
      sut = LocalLoadSurveys(fetchCacheStorage: fetchCacheStorageSpy);

      _mockFCSSuccess(mockValidData());
    },
  );

  test("Should call FetchCacheStorage with correct key", () async {
    await sut.load();
    verify(fetchCacheStorageSpy.fetch('surveys')).called(1);
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
            dateTime: DateTime.utc(2020,07,20),
            didAnswer: true,
          ),
          SurveyEntity(
            id: listData[1]['id'],
            question: listData[1]['question'],
            dateTime: DateTime.utc(2020,12,20),
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
      final future =  sut.load();
      expect(
        future,
        throwsA(DomainError.unexpected)
      );
    },
  );
}

class FetchCacheStorageSpy extends Mock implements FetchCacheStorage {}
