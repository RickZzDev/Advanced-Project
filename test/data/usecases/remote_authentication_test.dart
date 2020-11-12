import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:advancedProject/data_layer/http/http.dart';
import 'package:advancedProject/data_layer/use_cases/use_cases.dart';
import 'package:advancedProject/domain/usecases/usecases.dart';

//Aqui usamos o mockito para criar uma classe que implementa o httpClient
class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  RemoteAuthentication sut;
  HttpClientSpy httpClient;
  String url;

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
      final params = AuthenticationParams(
          email: faker.internet.email(), secret: faker.internet.password());
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
}
