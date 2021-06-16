import 'dart:convert';
import 'dart:typed_data';

import 'package:dart_crypto_kit/crypto_kdf/scrypt_with_master_key_derivation.dart';
import 'package:dart_crypto_kit/extensions/hex.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  int n = 4096;
  int r = 8;
  int p = 1;
  int keyLength = 32;

  var masterKey = Uint8List.fromList("WALLET_ID".codeUnits);
  var login = Uint8List.fromList("toma@tokend.org".codeUnits);
  var passphrase = Uint8List.fromList('qwe123'.codeUnits);
  var salt = base64Decode('67ufG1N/Rf+j2ugDaXaopw==');

  test('default encryption version', () {
    expect(
        1,
        ScryptWithMasterKeyDerivation(n, r, p, login, masterKey)
            .encryptionVersion);
  });

  test('derive', () {
    var expectedKey =
        "fc56f6752b28030cb34f1312e8e99ca536eea8d8f601637eacffa1cd156ac593"
            .toUint8list();
    var key = ScryptWithMasterKeyDerivation(n, r, p, login, masterKey)
        .derive(passphrase, salt, keyLength);

    print(key.hex());
    expect(key, expectedKey);
  });
}
