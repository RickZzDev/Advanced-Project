//Esta classe abstrata possui um método de request, porém como ela é abstrata não podemos instancia-la
import 'package:flutter/cupertino.dart';

abstract class HttpClient {
  Future<Map> request({
    @required String url,
    @required String method,
    Map body,
  });
}
