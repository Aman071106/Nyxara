import 'package:nyxara/domain/repositories/vault_repository.dart';

class Checkvaultusecase {
  final VaultRepository vaultRepository;
  Checkvaultusecase({required this.vaultRepository});
  Future<bool> execute(String email)
  async{
   return vaultRepository.isVaultPresent(email);
  }
}
