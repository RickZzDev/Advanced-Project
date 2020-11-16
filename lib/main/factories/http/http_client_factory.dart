import 'package:advancedProject/data_layer/http/http.dart';
import 'package:advancedProject/infra/http/http.dart';
import 'package:http/http.dart';

HttpClient makeHttpAdapter() {
  final client = Client();
  return HttpAdapter(client);
}
