import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:survey/data/http/http.dart';
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

  group("Shared", () {
    test(
      'Should throw serverError if invalid method is provided',
      () async {
        final future = sut.request(
          url: url,
          method: "invalid",
        );
        
        expect( future, throwsA(HttpError.serverError));
      },
    );
  });

  group(
    "POST",
    () {
      PostExpectation mockRequest() => when(
            client.post(
              any,
              body: anyNamed("body"),
              headers: anyNamed("headers"),
            ),
          );

      void mockResponse(int statusCode,
              {String body = '{"any_key":"any_value"}'}) =>
          mockRequest().thenAnswer(
            (_) async {
              return Response(body, statusCode);
            },
          );

      void mockError() =>
          mockRequest().thenThrow(Exception(""));
      

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
          final response = await sut
              .request(url: url, method: "post", body: {"EOQ": "EOAD"});
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

      test(
        'Should return null if post return 204',
        () async {
          mockResponse(204, body: '');

          final response = await sut.request(
            url: url,
            method: "post",
          );

          expect(response, null);
        },
      );

      test(
        'Should return null if post return 204 with data',
        () async {
          mockResponse(204);

          final response = await sut.request(
            url: url,
            method: "post",
          );

          expect(response, null);
        },
      );

      test(
        'Should return BadRequestError if post return 400',
        () async {
          mockResponse(400);

          final response = sut.request(
            url: url,
            method: "post",
          );

          expect(
            response,
            throwsA(HttpError.badRequest),
          );
        },
      );

      test(
        'Should return BadRequestError if post return 400',
        () async {
          mockResponse(400, body: '');

          final response = sut.request(
            url: url,
            method: "post",
          );

          expect(
            response,
            throwsA(HttpError.badRequest),
          );
        },
      );

      test(
        'Should return ServerError if post return 500',
        () async {
          mockResponse(500, body: '');

          final response = sut.request(
            url: url,
            method: "post",
          );

          expect(
            response,
            throwsA(HttpError.serverError),
          );
        },
      );

      test('Should return UnauthorizedError if post return 401', () async {
        mockResponse(401, body: '');

        final response = sut.request(
          url: url,
          method: "post",
        );

        expect(
          response,
          throwsA(HttpError.unauthorized),
        );
      });

      test('Should return ForbiddenError if post return 403', () async {
        mockResponse(403, body: '');

        final response = sut.request(
          url: url,
          method: "post",
        );

        expect(
          response,
          throwsA(HttpError.forbidden),
        );
      });

      test(
        'Should return NotFoundError if post return 404',
        () async {
          mockResponse(404, body: '');

          final response = sut.request(
            url: url,
            method: "post",
          );

          expect(
            response,
            throwsA(HttpError.notFound),
          );
        },
      );

      test(
        'Should throw serverError if post throws',
            () async {
          mockError();
          
          final future = sut.request(
            url: url,
            method: "post",
          );
    
          expect( future, throwsA(HttpError.serverError));
        },
      );


    },
  );
  
  group("GET", (){
  
    PostExpectation mockRequest() => when(
      client.get(
        any,
        headers: anyNamed("headers"),
      ),
    );
  
    void mockResponse(int statusCode,
        {String body = '{"any_key":"any_value"}'}) =>
        mockRequest().thenAnswer(
              (_) async {
            return Response(body, statusCode);
          },
        );
  
    void mockError() =>
        mockRequest().thenThrow(Exception(""));
  
  
    setUp(
          () {
        mockResponse(200);
      },
    );
  
    test(
      'Should call get with correct values',
          () async {
        await sut.request(
          url: url,
          method: "get",
        );
      
        verify(
          client.get(url,
              headers: {
                'content-type': 'application/json',
                'accept': 'application/json',
              },
          ),
        );
      },
    );


    test(
      'Should return data if get return 200',
          () async {
        final response = await sut
            .request(url: url, method: "get",);
        expect(response, {"any_key": "any_value"});
      },
    );

    test(
      'Should return null if get return 200 wihtout data',
          () async {
        mockResponse(200, body: '');
    
        final response = await sut.request(
          url: url,
          method: "get",
        );
    
        expect(response, null);
      },
    );


    test(
      'Should return null if get return 204',
          () async {
        mockResponse(204, body: '');
    
        final response = await sut.request(
          url: url,
          method: "get",
        );
    
        expect(response, null);
      },
    );

    test(
      'Should return null if get return 204 with data',
          () async {
        mockResponse(204);
    
        final response = await sut.request(
          url: url,
          method: "get",
        );
    
        expect(response, null);
      },
    );

    test(
      'Should return BadRequestError if get return 400',
          () async {
        mockResponse(400);
    
        final response = sut.request(
          url: url,
          method: "get",
        );
    
        expect(
          response,
          throwsA(HttpError.badRequest),
        );
      },
    );

    test(
      'Should return BadRequestError if get return 400',
          () async {
        mockResponse(400, body: '');
    
        final response = sut.request(
          url: url,
          method: "get",
        );
    
        expect(
          response,
          throwsA(HttpError.badRequest),
        );
      },
    );


    test('Should return UnauthorizedError if get return 401', () async {
      mockResponse(401, body: '');
  
      final response = sut.request(
        url: url,
        method: "get",
      );
  
      expect(
        response,
        throwsA(HttpError.unauthorized),
      );
    });
  
  
  });
}
