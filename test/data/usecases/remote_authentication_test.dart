import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:advancedProject/data_layer/http/http.dart';
import 'package:advancedProject/data_layer/use_cases/use_cases.dart';
import 'package:advancedProject/domain/usecases/usecases.dart';
import 'package:advancedProject/domain/helpers/helpers.dart';

//Aqui usamos o mockito para criar uma classe que implementa o httpClient
class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  RemoteAuthentication sut;
  HttpClientSpy httpClient;
  String url;
  AuthenticationParams params = AuthenticationParams(
      email: faker.internet.email(), secret: faker.internet.password());

  Map mockValidData() =>
      {"accessToken": faker.guid.guid(), "name": faker.person.name()};

  PostExpectation mockRequest() => when(httpClient.request(
      url: anyNamed("url"),
      method: anyNamed("method"),
      body: anyNamed("body")));

  void mockHttpData(Map data) {
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    //Instanciamos a classe Mockada
    httpClient = HttpClientSpy();
    //Criamos uma url fake com o Faker
    url = faker.internet.httpUrl();
    //Arrange
    //Intanciamos a classe que será testada e passamos os parâmetros
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    mockHttpData(mockValidData());
  });
  test(
    "Should call httpClient with corect values",
    () async {
      //Action
      await sut.auth(params);
      //Assert
      verify(
        httpClient.request(
          url: url,
          method: 'post',
          body: {
            "email": params.email,
            "password": params.secret,
          },
        ),
      );
    },
  );

  test(
    "Should throw unexpected error if HttpClient returns 400",
    () async {
      //Arrange
      mockHttpError(HttpError.badRequest);
      //Action
      final future = sut.auth(params);
      //Assert
      expect(future, throwsA(DomainError.unexpectedError));
    },
  );

  test(
    "Should throw unexpected error if HttpClient returns 404",
    () async {
      //Arrange
      mockHttpError(HttpError.notFound);
      //Action
      final future = sut.auth(params);
      //Assert
      expect(future, throwsA(DomainError.unexpectedError));
    },
  );
  test(
    "Should throw invalid credentials error if HttpClient returns 401",
    () async {
      //Arrange
      mockHttpError(HttpError.unauthorized);
      //Action
      final future = sut.auth(params);
      //Assert
      expect(future, throwsA(DomainError.invalidCredentials));
    },
  );

  test(
    "Should throw unexpected error if HttpClient returns 500",
    () async {
      //Arrange
      mockHttpError(HttpError.serverError);
      //Action
      final future = sut.auth(params);
      //Assert
      expect(future, throwsA(DomainError.unexpectedError));
    },
  );
  test(
    "Should return an AccountEntity if htppClient return 200",
    () async {
      final validData = mockValidData();
      //Arrange
      mockHttpData(validData);
      //Action
      final account = await sut.auth(params);
      //Assert
      expect(account.token, validData['accessToken']);
    },
  );

  test(
    "Should throw unexpected error  if htppClient return 200 with invalid data",
    () async {
      //Arrange
      mockHttpData({"invalid_key": "invalid_value"});
      //ACTION
      final future = sut.auth(params);
      //ASSERT
      expect(future, throwsA(DomainError.unexpectedError));
    },
  );
}
