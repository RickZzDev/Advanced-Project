import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';

import 'package:advancedProject/data_layer/http/http.dart';
import 'package:advancedProject/infra/http/http.dart';

class ClientSpy extends Mock implements Client {}

void main() {
  HttpAdapter sut;
  ClientSpy client;
  String url;
  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client);
    url = faker.internet.httpUrl();
  });

  group("SHARED", () {
    test(
      "Should throw server error if invalid method is provided",
      () async {
        final future = sut.request(
            url: url, method: 'invalid_method', body: {"any_key": "any_value"});

        expect(future, throwsA(HttpError.serverError));
      },
    );
  });

  group(
    "POST",
    () {
      PostExpectation mockRequest() => when(client.post(any,
          body: anyNamed("body"), headers: anyNamed("headers")));

      void mockError() {
        mockRequest().thenThrow(Exception());
      }

      void mockResponse(int statusCode,
          {String body = '{"any_key":"any_value"}'}) {
        mockRequest().thenAnswer((_) async => Response(body, statusCode));
      }

      setUp(() {
        mockResponse(200);
      });
      test(
        "Should call post with correct values",
        () async {
          await sut.request(
              url: url, method: 'post', body: {"any_key": "any_value"});

          verify(
            client.post(
              url,
              headers: {
                'content-type': 'application/json',
                'accept': 'application/json',
              },
              body: '{"any_key":"any_value"}',
            ),
          );
        },
      );

      test(
        "Should call post without body",
        () async {
          when(client.post(any, headers: anyNamed("headers"))).thenAnswer(
              (_) async => Response('{"any_key":"any_value"}', 200));
          await sut.request(url: url, method: 'post');

          verify(
            client.post(
              any,
              headers: anyNamed("headers"),
            ),
          );
        },
      );

      test(
        "Should return data(Map-type) if post return 200",
        () async {
          when(client.post(any, headers: anyNamed("headers"))).thenAnswer(
              (_) async => Response('{"any_key":"any_value"}', 200));

          final response = await sut.request(
            url: url,
            method: 'post',
          );

          expect(response, {"any_key": "any_value"});
        },
      );

      test(
        "Should return null if post return 200 without data",
        () async {
          when(client.post(any, headers: anyNamed("headers")))
              .thenAnswer((_) async => Response('', 200));

          final response = await sut.request(
            url: url,
            method: 'post',
          );

          expect(response, null);
        },
      );
      test(
        "Should return null if post return 204 without data",
        () async {
          mockResponse(204, body: '');

          final response = await sut.request(
            url: url,
            method: 'post',
          );

          expect(response, null);
        },
      );

      test(
        "Should return null if post return 204 with data",
        () async {
          mockResponse(204, body: '');

          final response = await sut.request(
            url: url,
            method: 'post',
          );

          expect(response, null);
        },
      );

      test(
        "Should return badRequest error if post return 400",
        () async {
          mockResponse(400, body: '');

          final future = sut.request(
            url: url,
            method: 'post',
          );

          expect(future, throwsA(HttpError.badRequest));
        },
      );

      test(
        "Should return badRequest error if post return 400",
        () async {
          mockResponse(400);

          final future = sut.request(
            url: url,
            method: 'post',
          );

          expect(future, throwsA(HttpError.badRequest));
        },
      );
      test(
        "Should return unauthorized error 401",
        () async {
          mockResponse(401);

          final future = sut.request(
            url: url,
            method: 'post',
          );

          expect(future, throwsA(HttpError.unauthorized));
        },
      );

      test(
        "Should return forbidden error 403",
        () async {
          mockResponse(403);

          final future = sut.request(
            url: url,
            method: 'post',
          );

          expect(
            future,
            throwsA(HttpError.forbidden),
          );
        },
      );

      test(
        "Should return not found error 404",
        () async {
          mockResponse(404);

          final future = sut.request(
            url: url,
            method: 'post',
          );

          expect(
            future,
            throwsA(HttpError.notFound),
          );
        },
      );

      test(
        "Should return serverError  if post return 500",
        () async {
          mockResponse(500);

          final future = sut.request(
            url: url,
            method: 'post',
          );

          expect(future, throwsA(HttpError.serverError));
        },
      );

      test(
        "Should return serverError  if post throws",
        () async {
          mockError();

          final future = sut.request(
            url: url,
            method: 'post',
          );

          expect(future, throwsA(HttpError.serverError));
        },
      );
    },
  );
}
