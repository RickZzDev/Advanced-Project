import 'package:advancedProject/data_layer/use_cases/save_current_account/local_save_current_account.dart';
import 'package:advancedProject/domain/usecases/save_current_account.dart';
import 'package:advancedProject/main/factories/cache/local_storage_adapter.dart';

SaveCurrentAccount makeLocalSaveCurrentAccount() {
  return LocalSaveCurrentAccount(
      saveSecureCacheStorage: makeLocalStorageAdapter());
}
