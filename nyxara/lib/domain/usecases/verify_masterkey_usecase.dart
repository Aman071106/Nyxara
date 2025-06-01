import 'package:nyxara/domain/repositories/vault_repository.dart';

class VerifyMasterkeyUsecase {
  final VaultRepository vaultRepository;
  VerifyMasterkeyUsecase({required this.vaultRepository});
  Future<bool> execute(String masterKey, String email) async {
    return vaultRepository.verifyKey(masterKey, email);
  }
}
