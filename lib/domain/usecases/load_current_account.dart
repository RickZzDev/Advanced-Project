import 'package:advancedProject/domain/entities/account_entity.dart';

abstract class SaveCurrentAccount {
  Future<AccountEntity> load();
}
