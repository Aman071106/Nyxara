import 'dart:developer';

import 'package:nyxara/domain/repositories/vault_repository.dart';

class FetchVaultItemsUsecase {
  final VaultRepository vaultRepository;
  FetchVaultItemsUsecase({required this.vaultRepository});
  Future<List<Map<String, String>>?> execute(String email) async {
    var ans = vaultRepository.getAll(email);
    log(ans.toString());
    return ans;
  }
}
