import 'package:nyxara/domain/repositories/vault_repository.dart';

class DeleteVaultitemUsecase {
  final VaultRepository vaultRepository;
 DeleteVaultitemUsecase({required this.vaultRepository});
   Future<bool> execute(
    String email,
    String title,
    String key,
    String masterKey,
  ) async {
    return vaultRepository.deleteItem(email, title, key, masterKey);
  }
}
