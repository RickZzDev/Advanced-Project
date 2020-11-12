//Esta classe é a responsavel por receber o httpClient e a url para fazer a requisição em si

import 'package:meta/meta.dart';

import '../http/http_client.dart';
import '../../domain/usecases/usecases.dart';
import '../../data_layer/http/http.dart';
import '../../domain/helpers/helpers.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({@required this.httpClient, @required this.url});
  Future<void> auth(AuthenticationParams params) async {
    try {
      await httpClient.request(
          url: url,
          method: 'post',
          body: RemoteAuthenticationParams.fromDomain(params).toJson());
    } on HttpError {
      throw DomainError.unexpectedError;
    }
  }
}

class RemoteAuthenticationParams {
  final String email;
  final String password;

  RemoteAuthenticationParams({
    @required this.email,
    @required this.password,
  });

  factory RemoteAuthenticationParams.fromDomain(AuthenticationParams params) =>
      RemoteAuthenticationParams(email: params.email, password: params.secret);

  Map toJson() => {"email": email, "password": password};
}
