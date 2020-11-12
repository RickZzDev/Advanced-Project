import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

//Esta classe é a responsavel por receber o httpClient e a url para fazer a requisição em si
class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({@required this.httpClient, @required this.url});
  Future<void> auth() async {
    await httpClient.request(url: url);
  }
}

//Esta classe abstrata possui um método de request, porém como ela é abstrata não podemos instancia-la
abstract class HttpClient {
  Future<void> request({@required String url});
}

//Aqui usamos o mockito para criar uma classe que implementa o httpClient
class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  test("Should call httpClient with corect url", () async {
    //Instanciamos a classe Mockada
    final httpClient = HttpClientSpy();
    //Criamos uma url fake com o Faker
    final url = faker.internet.httpUrl();
    //Arrange
    //Intanciamos a classe que será testada e passamos os parâmetros
    final sut = RemoteAuthentication(httpClient: httpClient, url: url);
    //Action
    //Chamando o auth
    await sut.auth();
    //Assert
    //Verificando se o request foi chamada com a url passada
    verify(httpClient.request(url: url));
    // expect(actual, matcher)
  });
}
