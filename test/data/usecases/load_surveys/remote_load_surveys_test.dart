import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/data/http/http.dart';
import 'package:survey/data/usecases/load_surveys/load_surveys.dart';
import 'package:survey/domain/entities/entities.dart';
import 'package:survey/domain/helpers/helpers.dart';

void main() {
  RemoteLoadSurveys sut;
  HttpClient httpClient;
  String url;
  List<Map> listData;

  PostExpectation _mockRequest() => when(
      httpClient.request(url: anyNamed("url"), method: anyNamed("method"),),);

  void _mockHttpError(HttpError httpError)=> _mockRequest().thenThrow(httpError);


  List<Map> mockValidData() => [
        {
          "id": faker.guid.guid(),
          "question": faker.randomGenerator.string(50),
          "didAnswer": faker.randomGenerator.boolean(),
          "dateTime": faker.date.dateTime().toIso8601String()
        },
        {
          "id": faker.guid.guid(),
          "question": faker.randomGenerator.string(50),
          "didAnswer": faker.randomGenerator.boolean(),
          "dateTime": faker.date.dateTime().toIso8601String()
        },
      ];

  void mockSuccessCall(List<Map> data) =>
      _mockRequest().thenAnswer((_) async => data);

  setUp(
    () {
      listData = mockValidData();
      url = faker.internet.httpUrl();
      httpClient = HttpClientSpy();
      sut = RemoteLoadSurveys(httpClient: httpClient, url: url);

      mockSuccessCall(listData);
    },
  );

  test("Should call HttpClient with correct values", () async {
    await sut.load();

    verify(
      httpClient.request(
        url: url,
        method: "get",
      ),
    );
  });

  test("Should return surveys on 200", () async {
    final response = await sut.load();

    expect(
      response,
      [
        SurveyEntity(
            id: listData[0]['id'],
            question: listData[0]['question'],
            dateTime: DateTime.parse(listData[0]['dateTime']),
            didAnswer: listData[0]['didAnswer']),
        SurveyEntity(
            id: listData[1]['id'],
            question: listData[1]['question'],
            dateTime: DateTime.parse(listData[1]['dateTime']),
            didAnswer: listData[1]['didAnswer']),
      ],
    );
  });

  test(
    "Shoud throw an UnexpectedError if HttpClient returns 200 with invalid data",
        () async {
          mockSuccessCall([
        {"random": faker.randomGenerator.string(50)}
      ]);
    
      final future = sut.load();
    
      expect(
        future,
        throwsA(DomainError.unexpected),
      );
    },
  );

  /// TEST ON 404
  test(
    "Shoud throw an UnexpectedError if HttpClient returns 404",
        () async {
      _mockHttpError(HttpError.notFound);
    
      final future = sut.load();
    
      expect(
        future,
        throwsA(DomainError.unexpected),
      );
    },
  );

  /// TEST ON 500
  test(
    "Shoud throw an UnexpectedError if HttpClient returns 500",
        () async {
      _mockHttpError(HttpError.serverError);
    
      final future = sut.load();
    
      expect(
        future,
        throwsA(DomainError.unexpected),
      );
    },
  );

  /// TEST ON 401
  test(
    "Shoud throw an InvalidCrendential if HttpClient returns 403",
        () async {
      _mockHttpError(HttpError.forbidden);
    
      final future = sut.load();
    
      expect(
        future,
        throwsA(DomainError.accessDenied),
      );
    },
  );
  
  
}

class HttpClientSpy extends Mock implements HttpClient {}
