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

  setUp(() {
    //Instanciamos a classe Mockada
    httpClient = HttpClientSpy();
    //Criamos uma url fake com o Faker
    url = faker.internet.httpUrl();
    //Arrange
    //Intanciamos a classe que será testada e passamos os parâmetros
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
  });
  test(
    "Should call httpClient with corect values",
    () async {
      final accessToken = faker.guid.guid();
      when(
        httpClient.request(
          url: anyNamed("url"),
          method: anyNamed("method"),
          body: anyNamed("body"),
        ),
      ).thenAnswer((_) async =>
          {"accessToken": accessToken, "name": faker.person.name()});
      //Action
      //Chamando o auth
      await sut.auth(params);
      //Assert
      //Verificando se o request foi chamada com a url passada
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
      // expect(actual, matcher)
    },
  );

  test(
    "Should throw unexpected error if HttpClient returns 400",
    () async {
      //O when será ativado justamente quando o request for chamado
      //Após ele ser chamado, será lançado um HttpError
      when(
        httpClient.request(
          url: anyNamed("url"),
          method: anyNamed("method"),
          body: anyNamed("body"),
        ),
      ).thenThrow(HttpError.badRequest);
      //Action
      //Chamando o auth
      final future = sut.auth(params);
      //Assert
      //Verifica se foi lançado um domain error
      expect(future, throwsA(DomainError.unexpectedError));
    },
  );

  test(
    "Should throw unexpected error if HttpClient returns 404",
    () async {
      //O when será ativado justamente quando o request for chamado
      //Após ele ser chamado, será lançado um HttpError
      when(
        httpClient.request(
          url: anyNamed("url"),
          method: anyNamed("method"),
          body: anyNamed("body"),
        ),
      ).thenThrow(HttpError.notFound);
      //Action
      //Chamando o auth
      final future = sut.auth(params);
      //Assert
      //Verifica se foi lançado um domain error
      expect(future, throwsA(DomainError.unexpectedError));
    },
  );
  test(
    "Should throw invalid credentials error if HttpClient returns 401",
    () async {
      //O when será ativado justamente quando o request for chamado
      //Após ele ser chamado, será lançado um HttpError
      when(
        httpClient.request(
          url: anyNamed("url"),
          method: anyNamed("method"),
          body: anyNamed("body"),
        ),
      ).thenThrow(HttpError.unauthorized);
      //Action
      //Chamando o auth
      final future = sut.auth(params);
      //Assert
      //Verifica se foi lançado um domain error
      expect(future, throwsA(DomainError.invalidCredentials));
    },
  );

  test(
    "Should throw unexpected error if HttpClient returns 500",
    () async {
      //O when será ativado justamente quando o request for chamado
      //Após ele ser chamado, será lançado um HttpError
      when(
        httpClient.request(
          url: anyNamed("url"),
          method: anyNamed("method"),
          body: anyNamed("body"),
        ),
      ).thenThrow(HttpError.serverError);
      //Action
      //Chamando o auth
      final future = sut.auth(params);
      //Assert
      //Verifica se foi lançado um domain error
      expect(future, throwsA(DomainError.unexpectedError));
    },
  );
  test(
    "Should return an AccountEntity if htppClient return 200",
    () async {
      final accessToken = faker.guid.guid();
      //O when será ativado justamente quando o request for chamado
      //Após ele ser chamado, será lançado um HttpError
      when(
        httpClient.request(
          url: anyNamed("url"),
          method: anyNamed("method"),
          body: anyNamed("body"),
        ),
      ).thenAnswer((_) async =>
          {"accessToken": accessToken, "name": faker.person.name()});
      //Action
      //Chamando o auth
      final account = await sut.auth(params);
      //Assert
      //Verifica se foi lançado um domain error
      expect(account.token, accessToken);
    },
  );

  test(
    "Should throw unexpected error  if htppClient return 200 with invalid data",
    () async {
      final accessToken = faker.guid.guid();
      //O when será ativado justamente quando o request for chamado
      //Após ele ser chamado, será lançado um HttpError
      when(
        httpClient.request(
          url: anyNamed("url"),
          method: anyNamed("method"),
          body: anyNamed("body"),
        ),
      ).thenAnswer((_) async => {"invalid_key": "invalid_value"});
      //Action
      //Chamando o auth
      final future = sut.auth(params);
      //Assert
      //Verifica se foi lançado um domain error
      expect(future, throwsA(DomainError.unexpectedError));
    },
  );
}
