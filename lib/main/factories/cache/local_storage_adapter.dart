import 'package:advancedProject/data_layer/http/http.dart';
import 'package:advancedProject/infra/cache/local_storage_adapter.dart';
import 'package:advancedProject/infra/http/http.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

LocalStorageAdapter makeLocalStorageAdapter() {
  final secureStorage = FlutterSecureStorage();
  return LocalStorageAdapter(secureStorage: secureStorage);
}
