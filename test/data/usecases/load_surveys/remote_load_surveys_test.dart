import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/data/http/http.dart';
import 'package:survey/data/usecases/load_surveys/load_surveys.dart';

void main() {
  RemoteLoadSurveys sut;
  HttpClient httpClient;
  String url;

  setUp(() {
    url = faker.internet.httpUrl();
    httpClient = HttpClientSpy();
    sut = RemoteLoadSurveys(httpClient: httpClient, url: url);
  });

  test("Should call HttpClient with correct values", () async {
    await sut.load();

    verify(
      httpClient.request(
        url: url,
        method: "get",
      ),
    );
  });
}

class HttpClientSpy extends Mock implements HttpClient {}
