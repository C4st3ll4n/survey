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
  setUp((){
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
          await sut.request(url: url, method: "post");

          verify(
            client.post(
              url,
              headers: {
                'content-type': 'application/json',
                'accept': 'application/json',
              },
            ),
          );
        },
      );
    },
  );

  group("GET", () {});
}
