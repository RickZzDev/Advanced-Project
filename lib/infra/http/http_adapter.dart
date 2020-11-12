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
    final response = await client.post(
      url,
      headers: headers,
      body: jsonBody,
    );
    return _handleResponse(response);
  }

  Map _handleResponse(Response _response) {
    if (_response.statusCode == 200)
      return _response.body.isEmpty ? null : jsonDecode(_response.body);
    else if (_response.statusCode == 204)
      return null;
    else
      throw HttpError.badRequest;
  }
}
