import 'package:nyxara/domain/repositories/vault_repository.dart';

class PutVaultitemUsecase {
  final VaultRepository vaultRepository;
  PutVaultitemUsecase({required this.vaultRepository});
  Future<bool> execute(
    String email,
    String title,
    String key,
    String masterKey,
    String newValue,
  ) async {
    return vaultRepository.updateItem(email, title, key, masterKey, newValue);
  }
}
