abstract class VaultRepository {
  Future<String?> createVault(String masterKey, String email);
  Future<bool> isVaultPresent(String email);
  Future<bool> putItem(
    String email,
    String title,
    String key,
    String value,
    String masterKey,
  );
  Future<bool> updateItem(
    String email,
    String title,
    String key,
    String masterKey,
    String newValue,
  );
  Future<bool> deleteItem(
    String email,
    String title,
    String key,
    String masterKey,
  );
  Future<String?> reveal(String masterKey, String encryptedValue);
  Future<bool> verifyKey(String masterKey, String email);
  Future<List<Map<String, String>>?> getAll(String email);
}
