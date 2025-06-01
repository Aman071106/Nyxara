import 'dart:developer';

import 'package:cryptography/cryptography.dart';
import 'package:nyxara/core/utils/vault_encryption_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VaultDatasource {
  List<int> nonce;
  String verificationPass;
  String tableName;

  VaultDatasource({
    required this.nonce,
    required this.verificationPass,
    required this.tableName,
  });

  //create vault-returns masterKey at creation of vault to show to user Once
  Future<String?> createVault(String masterKey, String email) async {
    try {
      log("Tryin to create vault...");
      SecretKey derivedKey = await deriveKey(masterKey, nonce);
      log("derivedKey= ${derivedKey.hashCode}");
      String record =
          (await Supabase.instance.client.from(tableName).insert({
                'email': email,
                'title': 'nyxara',
                'key': 'nyxara',
                'value': await encryptWithKey(verificationPass, derivedKey),
              }).select())
              .toString();
      log("Inside Vault creation...$record");
      return masterKey;
    } catch (e) {
      log("Inside Vault creation error--- $e");
      return null;
    }
  }

  //verify vault is present or not
  Future<bool> isVaultPresent(String email) async {
    try {
      return (await Supabase.instance.client
          .from(tableName)
          .select()
          .eq('title', 'nyxara')
          .eq('key', 'nyxara')
          .eq('email', email)).isNotEmpty;
    } catch (e) {
      log("Vault presence error: $e");
      return false;
    }
  }

  //put item
  Future<bool> putItem(
    String email,
    String title,
    String key,
    String value,
    String masterKey,
  ) async {
    try {
      bool iskeycorrect = await verifyKey(masterKey, email);
      if (!iskeycorrect) return false;
      // Check for duplicate
    final existing = await Supabase.instance.client
        .from(tableName)
        .select()
        .eq('email', email)
        .eq('title', title)
        .eq('key', key)
        .maybeSingle();

    if (existing != null) {
      log("Duplicate entry exists: $existing");
      return false;
    }
      return (await Supabase.instance.client.from(tableName).insert({
            'email': email,
            'key': key,
            'value': await encryptWithKey(
              value,
              await deriveKey(masterKey, nonce),
            ),
            'title': title,
          }).select())
          .isNotEmpty;
    } catch (e) {
      log("Error inserting item in vault... $e");
      return false;
    }
  }

  //update item
  Future<bool> updateItem(
    String email,
    String title,
    String key,
    String masterKey,
    String newValue,
  ) async {
    try {
      SecretKey derivedKey = await deriveKey(masterKey, nonce);
      bool iskeycorrect = await verifyKey(masterKey, email);
      if (!iskeycorrect) return false;
      return (await Supabase.instance.client
              .from(tableName)
              .update({'value': await encryptWithKey(newValue, derivedKey)})
              .eq('title', title)
              .eq('email', email)
              .eq('key', key)
              .select())
          .isNotEmpty;
    } catch (e) {
      log("Error updating item in vault... $e");
      return false;
    }
  }

  //delete item
  Future<bool> deleteItem(
    String email,
    String title,
    String key,
    String masterKey,
  ) async {
    try {
      
      bool iskeycorrect = await verifyKey(masterKey, email);
      if (!iskeycorrect) return false;
      return (await Supabase.instance.client
              .from(tableName)
              .delete()
              .eq('title', title)
              .eq('email', email)
              .eq('key', key)
              .select())
          .isNotEmpty;
    } catch (e) {
      log("Error deleting item in vault... $e");
      return false;
    }
  }

  //reveal value
  Future<String?> reveal(String masterKey, String encryptedValue) async {
    try {
      return await decryptWithKey(
        encryptedValue,
        await deriveKey(masterKey, nonce),
      );
    } catch (e) {
      log("Error Inside reveal value--: $e");
      return null;
    }
  }

  //verify masterKey
  Future<bool> verifyKey(String masterKey, String email) async {
    try {
      String encryptedValue =
          (await Supabase.instance.client
              .from(tableName)
              .select()
              .eq('email', email)
              .eq('key', 'nyxara')
              .eq('title', 'nyxara'))[0]['value'];
      return verificationPass ==
          await decryptWithKey(
            encryptedValue,
            await deriveKey(masterKey, nonce),
          );
    } catch (e) {
      log("Inside Vault datasource checking masterKey--- $e");
      return false;
    }
  }

  //get all items
  Future<List<Map<String, String>>?> getAll(String email) async {
    try {
      log("Fetching items....");
      final result = await Supabase.instance.client
          .from(tableName)
          .select()
          .eq('email', email);
      var itemCheck;
      for (var item in result) {
        if (item['key'] == 'nyxara') {
          // log("Yes1");
          itemCheck = item;
        } else {
          // log("Yes2");
          item.remove('id');
        }
      }
      result.remove(itemCheck);

      return result
          .map<Map<String, String>>((entry) => Map<String, String>.from(entry))
          .toList();
    } catch (e) {
      log("Error fetching items --- $e");
      return null;
    }
  }
}
