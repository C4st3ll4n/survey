import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/infra/http/http_adapter.dart';
import 'package:test/test.dart';

class ClientSpy extends Mock implements Client {}

void main() {
  Client client;
  HttpAdapter sut;
  String url;

  /// SETUP GLOBAL
  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client);
    url = faker.internet.httpUrl();
  });

  group(
    "POST",
    () {
      PostExpectation mockRequest() => when(
            client.post(
              any,
              headers: anyNamed("headers"),
            ),
          );

      void mockResponse(int statusCode,
          {String body = '{"any_key":"any_value"}'}) {
        mockRequest().thenAnswer(
          (_) async => Response(body, 200),
        );
      }

      setUp(
        () {
          mockResponse(200);
        },
      );

      test(
        'Should call post with correct values',
        () async {
          await sut.request(
            url: url,
            method: "post",
            body: {'any_key': 'any_value'},
          );

          verify(
            client.post(url,
                headers: {
                  'content-type': 'application/json',
                  'accept': 'application/json',
                },
                body: '{"any_key":"any_value"}'),
          );
        },
      );

      test(
        'Should call post without body',
        () async {
          await sut.request(
            url: url,
            method: "post",
          );

          verify(
            client.post(
              any,
              headers: anyNamed('headers'),
            ),
          );
        },
      );

      test(
        'Should return data if post return 200',
        () async {
          final response = await sut.request(
            url: url,
            method: "post",
          );

          expect(response, {"any_key": "any_value"});
        },
      );

      test(
        'Should return null if post return 200 wihtout data',
        () async {
          mockResponse(200, body: '');

          final response = await sut.request(
            url: url,
            method: "post",
          );

          expect(response, null);
        },
      );
    },
  );

  group("GET", () {});
}