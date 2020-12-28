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
      
      test(
        'Should call post with correct values',
        () async {
  
          when(
            client.post(
              any, body: anyNamed("body"),
              headers: anyNamed("headers"),
            ),
          ).thenAnswer(
                (realInvocation) async => Response('{"any_key":"any_value"}', 200),
          );
          
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
  
          when(
            client.post(
              any,
              headers: anyNamed("headers"),
            ),
          ).thenAnswer(
                (realInvocation) async => Response('{"any_key":"any_value"}', 200),
          );
          
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
          when(
            client.post(
              any,
              headers: anyNamed("headers"),
            ),
          ).thenAnswer(
            (realInvocation) async => Response('{"any_key":"any_value"}', 200),
          );

          final response = await sut.request(
            url: url,
            method: "post",
          );

          expect(response, {"any_key": "any_value"});
        },
      );
    },
  );

  group("GET", () {});
}
