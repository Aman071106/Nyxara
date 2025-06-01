import 'dart:convert';
import 'package:cryptography/cryptography.dart';

final algorithm = AesCbc.with128bits(
  macAlgorithm: Hmac.sha256(),
);

/// Derives a symmetric key from the user's password and salt.
Future<SecretKey> deriveKey(String password, List<int> salt) async {
  final pbkdf2 = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: 100000,
    bits: 128,
  );
  return await pbkdf2.deriveKey(
    secretKey: SecretKey(password.codeUnits),
    nonce: salt,
  );
}

Future<String> encryptWithKey(String plainText, SecretKey secretKey) async {
  final iv = algorithm.newNonce();
  final encrypted = await algorithm.encrypt(
    utf8.encode(plainText),
    secretKey: secretKey,
    nonce: iv,
  );

  final ivBase64 = base64Encode(encrypted.nonce);
  final cipherBase64 = base64Encode(encrypted.cipherText);
  final macBase64 = base64Encode(encrypted.mac.bytes);
  return '$ivBase64:$cipherBase64:$macBase64';
}

Future<String> decryptWithKey(String encryptedText, SecretKey secretKey) async {
  final parts = encryptedText.split(':');
  if (parts.length != 3) throw Exception("Invalid encrypted format");

  final iv = base64Decode(parts[0]);
  final cipherText = base64Decode(parts[1]);
  final mac = base64Decode(parts[2]);

  final secretBox = SecretBox(cipherText, nonce: iv, mac: Mac(mac));
  final clearBytes = await algorithm.decrypt(secretBox, secretKey: secretKey);

  return utf8.decode(clearBytes);
}
