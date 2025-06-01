import 'package:nyxara/domain/repositories/vault_repository.dart';

class DeleteVaultitemUsecase {
  final VaultRepository vaultRepository;
 DeleteVaultitemUsecase({required this.vaultRepository});
   Future<bool> execute(
    String email,
    String title,
    String key,
    String value,
    String masterKey,
  ) async {
    return vaultRepository.putItem(email, title, key, value, masterKey);
  }
}
