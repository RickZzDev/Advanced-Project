import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:advancedProject/domain/usecases/authentication.dart';

//Esta classe é a responsavel por receber o httpClient e a url para fazer a requisição em si
class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({@required this.httpClient, @required this.url});
  Future<void> auth(AuthenticationParams params) async {
    final body = {"email": params.email, "password": params.secret};
    await httpClient.request(url: url, method: 'post', body: body);
  }
}

//Esta classe abstrata possui um método de request, porém como ela é abstrata não podemos instancia-la
abstract class HttpClient {
  Future<void> request({
    @required String url,
    @required String method,
    Map body,
  });
}

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
