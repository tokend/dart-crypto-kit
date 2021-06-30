import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:dart_crypto_kit/crypto_kdf/scrypt_key_derivation.dart';
import 'package:pointycastle/export.dart';

class ScryptWithMasterKeyDerivation extends ScryptKeyDerivation {
  static const MASTER_KEY_MAC_ALG = "SHA-256/HMAC";

  late Uint8List login;
  late Uint8List masterKey;

  ScryptWithMasterKeyDerivation(
      int n, r, p, Uint8List login, Uint8List masterKey)
      : super(n, r, p) {
    this.login = login;
    this.masterKey = masterKey;
  }

  ///Version byte of the encryption method. 1 by default.
  var encryptionVersion = 1;

  @override
  Uint8List derive(Uint8List passphrase, Uint8List salt, int keyLengthBytes) {
    var composedRawSalt = Uint8List(1 + salt.length + login.length);
    composedRawSalt[0] = encryptionVersion;
    for (int i = 0; i < salt.length; i++) {
      composedRawSalt[i + 1] = salt[i];
    }

    for (int i = 0; i < login.length; i++) {
      composedRawSalt[i + salt.length + 1] = login[i];
    }

    var composedSalt = sha256.convert(composedRawSalt).bytes;
    composedRawSalt.fillRange(0, composedRawSalt.length, 0);

    var scryptParameters =
        ScryptParameters(n, r, p, keyLengthBytes, Uint8List.fromList(composedSalt));
    var scrypt = Scrypt();
    scrypt.init(scryptParameters);

    var key = Uint8List(keyLengthBytes);
    scrypt.deriveKey(passphrase, 0, key, 0);
    composedSalt.fillRange(0, composedSalt.length, 0);

    var hmacSha256 = Hmac(sha256, key);
    var digest = hmacSha256.convert(masterKey);
    key.fillRange(0, key.length, 0);

    return Uint8List.fromList(digest.bytes);
  }
}