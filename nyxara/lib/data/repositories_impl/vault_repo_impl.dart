import 'package:nyxara/data/datasources/vault_dataSource.dart';
import 'package:nyxara/domain/repositories/vault_repository.dart';

class VaultRepoImpl implements VaultRepository {
  final VaultDatasource vaultService;
  VaultRepoImpl({required this.vaultService});
  @override
  Future<String?> createVault(String masterKey, String email) async {
    return await vaultService.createVault(masterKey, email);
  }

  @override
  Future<bool> deleteItem(
    String email,
    String title,
    String key,
    String masterKey,
  ) async {
    return await vaultService.deleteItem(email, title, key, masterKey);
  }

  @override
  Future<List<Map<String, String>>?> getAll(String email) async {
    //should be like entity-model conversion-do later
    return await vaultService.getAll(email);
  }

  @override
  Future<bool> isVaultPresent(String email) async {
    return await vaultService.isVaultPresent(email);
  }

  @override
  Future<bool> putItem(
    String email,
    String title,
    String key,
    String value,
    String masterKey,
  ) async {
    return await vaultService.putItem(email, title, key, value, masterKey);
  }

  @override
  Future<String?> reveal(String masterKey, String encryptedValue) async {
    return await vaultService.reveal(masterKey, encryptedValue);
  }

  @override
  Future<bool> updateItem(
    String email,
    String title,
    String key,
    String masterKey,
    String newValue,
  ) async {
    return await vaultService.updateItem(
      email,
      title,
      key,
      masterKey,
      newValue,
    );
  }

  @override
  Future<bool> verifyKey(String masterKey, String email) async {
    return await vaultService.verifyKey(masterKey, email);
  }
}
