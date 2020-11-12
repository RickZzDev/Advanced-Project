import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:meta/meta.dart';

import 'package:http/http.dart';
import 'package:advancedProject/data_layer/http/http.dart';

class ClientSpy extends Mock implements Client {}

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);
  Future<Map> request(
      {@required String url, @required String method, Map body}) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };
    final jsonBody = body != null ? jsonEncode(body) : null;
    final response = await client.post(
      url,
      headers: headers,
      body: jsonBody,
    );
    if (response.statusCode == 200)
      return response.body.isEmpty ? null : jsonDecode(response.body);
    else {
      return null;
    }
  }
}

void main() {
  HttpAdapter sut;
  ClientSpy client;
  String url;
  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client);
    url = faker.internet.httpUrl();
  });
  group(
    "POST",
    () {
      PostExpectation mockRequest() => when(client.post(any,
          body: anyNamed("body"), headers: anyNamed("headers")));
      void mockResponse(int statusCode,
          {String body = '{"any_key":"any_value"}'}) {
        mockRequest().thenAnswer((_) async => Response(body, 200));
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
    },
  );
}
