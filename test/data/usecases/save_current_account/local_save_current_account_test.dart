import 'package:advancedProject/data_layer/cache/save_secure_cache_storage.dart';
import 'package:advancedProject/data_layer/use_cases/save_current_account/local_save_current_account.dart';
import 'package:advancedProject/domain/entities/account_entity.dart';
import 'package:advancedProject/domain/helpers/domain_error.dart';
import 'package:advancedProject/domain/usecases/save_current_account.dart';
import 'package:faker/faker.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class SaveSecureCacheStorageSpy extends Mock implements SaveSecureCacheStorage {
}

void main() {
  LocalSaveCurrentAccount sut;
  SaveSecureCacheStorageSpy saveSecureCacheStorage;
  AccountEntity account;

  setUp(() {
    saveSecureCacheStorage = SaveSecureCacheStorageSpy();
    sut =
        LocalSaveCurrentAccount(saveSecureCacheStorage: saveSecureCacheStorage);

    account = AccountEntity(faker.guid.guid());
  });

  void mockError() {
    when(saveSecureCacheStorage.saveSecure(
            key: anyNamed('key'), value: anyNamed('value')))
        .thenThrow(Exception());
  }

  test('Shoudl call SaveCacheStorage with correct values', () async {
    await sut.save(account);
    verify(
        saveSecureCacheStorage.saveSecure(key: 'token', value: account.token));
  });

  test('Shoudl throw unexpected error if save cache storage throws', () async {
    mockError();

    final future = sut.save(account);
    expect(future, throwsA(DomainError.unexpectedError));
  });
}
