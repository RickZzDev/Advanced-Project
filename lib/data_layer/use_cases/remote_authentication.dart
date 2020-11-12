//Esta classe é a responsavel por receber o httpClient e a url para fazer a requisição em si

import 'package:flutter/cupertino.dart';

import 'package:advancedProject/domain/usecases/authentication.dart';

import '../http/http_client.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({@required this.httpClient, @required this.url});
  Future<void> auth(AuthenticationParams params) async {
    await httpClient.request(url: url, method: 'post', body: params.toJson());
  }
}
