import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/data/http/http.dart';
import 'package:survey/data/usecases/usecases.dart';
import 'package:survey/domain/entities/entities.dart';
import 'package:survey/domain/helpers/helpers.dart';

void main() {
  RemoteLoadSurveyResult sut;
  HttpClient httpClient;
  String url;
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
      httpClient = HttpClientSpy();
      sut = RemoteLoadSurveyResult(httpClient: httpClient, url: url);

      mockSuccessCall(mockValidData());
    },
  );

  test("Should call HttpClient with correct values", () async {
    await sut.loadBySurvey();

    verify(
      httpClient.request(
        url: url,
        method: "get",
      ),
    );
  });

  test("Should return survey on 200", () async {
    final response = await sut.loadBySurvey();

    expect(response,
        SurveyResultEntity(
          surveyId: surveyResult['surveyId'],
          question: surveyResult['question'],
          answers: [
            SurveyAnswerEntity(
                answer: surveyResult['answers'][0]['answer'],
                percent: surveyResult['answers'][0]['percent'],
                isCurrentAnswer: surveyResult['answers'][0]
                    ['isCurrentAccountAnswer'],
                image: surveyResult['answers'][0]['image']),
            SurveyAnswerEntity(
              answer: surveyResult['answers'][1]['answer'],
              percent: surveyResult['answers'][1]['percent'],
              isCurrentAnswer: surveyResult['answers'][1]
                  ['isCurrentAccountAnswer'],
            ),
          ],
        ),
        );
  });

  test(
    "Shoud throw an UnexpectedError if HttpClient returns 200 with invalid data",
    () async {
      mockSuccessCall({"random": faker.randomGenerator.string(50)});

      final future = sut.loadBySurvey();

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

      final future = sut.loadBySurvey();

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

      final future = sut.loadBySurvey();

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

      final future = sut.loadBySurvey();

      expect(
        future,
        throwsA(DomainError.accessDenied),
      );
    },
  );
}

class HttpClientSpy extends Mock implements HttpClient {}
