import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/data/http/http.dart';
import 'package:survey/data/usecases/usecases.dart';
import 'package:survey/domain/entities/entities.dart';
import 'package:survey/domain/helpers/helpers.dart';

void main() {
  RemoteSaveSurveyResult sut;
  HttpClient httpClient;
  String url;
  String mockedAnswer;
  Map surveyResult;

  PostExpectation _mockRequest() => when(
        httpClient.request(
          url: anyNamed("url"),
          method: anyNamed("method"),
        ),
      );

  void _mockHttpError(HttpError httpError) =>
      _mockRequest().thenThrow(httpError);

  Map mockValidData() => {
        "surveyId": faker.guid.guid(),
        "question": faker.randomGenerator.string(50),
        "answers": [
          {
            "image": faker.internet.httpUrl(),
            "answer": faker.randomGenerator.string(50),
            "percent": faker.randomGenerator.integer(100),
            "count": faker.randomGenerator.integer(1000),
            "isCurrentAccountAnswer": faker.randomGenerator.boolean(),
          },
          {
            "answer": faker.randomGenerator.string(50),
            "percent": faker.randomGenerator.integer(100),
            "count": faker.randomGenerator.integer(1000),
            "isCurrentAccountAnswer": faker.randomGenerator.boolean(),
          }
        ],
        "date": faker.date.dateTime().toIso8601String()
      };

  void mockSuccessCall(Map data) {
    surveyResult = data;
    _mockRequest().thenAnswer((_) async => data);
  }

  setUp(
    () {
      url = faker.internet.httpUrl();
      mockedAnswer = faker.lorem.sentence();
      httpClient = HttpClientSpy();
      sut = RemoteSaveSurveyResult(httpClient: httpClient, url: url);

      mockSuccessCall(mockValidData());
    },
  );

  test("Should call HttpClient with correct values", () async {
    await sut.save(answer: mockedAnswer);

    verify(
      httpClient.request(
        url: url,
        method: "put",
        body: {'answer':mockedAnswer}),
    );
  });

}

class HttpClientSpy extends Mock implements HttpClient {}
