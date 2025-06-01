import 'package:nyxara/domain/repositories/vault_repository.dart';

class Createvaultusecase {
  final VaultRepository vaultRepository;
  Createvaultusecase({required this.vaultRepository});
  Future<String?> execute(String masterKey, String email)
  async{
   return vaultRepository.createVault(masterKey, email);
  }
}
