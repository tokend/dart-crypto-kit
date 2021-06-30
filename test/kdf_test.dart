import 'dart:convert';
import 'dart:typed_data';

import 'package:dart_crypto_kit/crypto_kdf/scrypt_key_derivation.dart';
import 'package:dart_crypto_kit/extensions/hex.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  int n = 4096;
  int r = 8;
  int p = 1;
  int keyLength = 32;
  Uint8List passphrase = Uint8List.fromList('qwe123'.codeUnits);
  Uint8List salt = base64Decode('67ufG1N/Rf+j2ugDaXaopw==');

  test('kdf', () {
    var expectedKey =
        "88061aa9806b1007dbad487c65c0aa54fed2e8e1b8a4731c3ebbfb87f2ecdf21"
            .toUint8list();
    var key = ScryptKeyDerivation(n, r, p).derive(passphrase, salt, keyLength);
    expect(key, expectedKey);
  });
}
