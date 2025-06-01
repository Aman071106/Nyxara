import 'package:nyxara/domain/repositories/vault_repository.dart';

class RevealUsecase {
  final VaultRepository vaultRepository;
  RevealUsecase({required this.vaultRepository});
  Future<String?> execute(String masterKey, String encryptedValue) async {
    return vaultRepository.reveal(masterKey, encryptedValue);
  }
}
