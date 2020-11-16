import 'package:advancedProject/data_layer/use_cases/use_cases.dart';
import 'package:advancedProject/domain/usecases/authentication.dart';
import 'package:advancedProject/main/factories/http/http.dart';

Authentication makeRemoteAuthentication() {
  return RemoteAuthentication(
      httpClient: makeHttpAdapter(), url: makeApiUrl('login'));
}
