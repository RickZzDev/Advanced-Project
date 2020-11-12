import 'dart:convert';

import 'package:http/http.dart';
import 'package:meta/meta.dart';

import '../../data_layer/http/http.dart';

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
    var response = Response('', 500);
    try {
      if (method == "post") {
        response = await client.post(
          url,
          headers: headers,
          body: jsonBody,
        );
      }
    } catch (e) {
      throw HttpError.serverError;
    }

    return _handleResponse(response);
  }

  Map _handleResponse(Response _response) {
    if (_response.statusCode == 200)
      return _response.body.isEmpty ? null : jsonDecode(_response.body);
    else if (_response.statusCode == 204)
      return null;
    else if (_response.statusCode == 400)
      throw HttpError.badRequest;
    else if (_response.statusCode == 401)
      throw HttpError.unauthorized;
    else if (_response.statusCode == 403)
      throw HttpError.forbidden;
    else if (_response.statusCode == 404)
      throw HttpError.notFound;
    else
      throw HttpError.serverError;
  }
}
