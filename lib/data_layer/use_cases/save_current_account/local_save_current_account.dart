import 'package:advancedProject/data_layer/cache/save_secure_cache_storage.dart';
import 'package:advancedProject/domain/entities/account_entity.dart';
import 'package:advancedProject/domain/helpers/domain_error.dart';
import 'package:advancedProject/domain/usecases/save_current_account.dart';
import 'package:meta/meta.dart';

class LocalSaveCurrentAccount implements SaveCurrentAccount {
  final SaveSecureCacheStorage saveSecureCacheStorage;
  LocalSaveCurrentAccount({@required this.saveSecureCacheStorage});
  Future<void> save(AccountEntity account) async {
    try {
      await saveSecureCacheStorage.saveSecure(
          key: 'token', value: account.token);
    } catch (e) {
      throw DomainError.unexpectedError;
    }
  }
}
