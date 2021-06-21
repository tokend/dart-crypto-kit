import 'dart:convert';
import 'dart:typed_data';

import 'package:dart_crypto_kit/crypto_cipher/aes256gcm.dart';
import 'package:dart_crypto_kit/extensions/hex.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  List<int> dataList = 'TokenD is awesome'.codeUnits;

  Uint8List data = Uint8List.fromList(dataList);
  var key = "2e0c7a28545d4c53a1f4b9ef82245d7da853c7f0b0ae949040faedaa60c23c0b"
      .toUint8list();
  var iv = base64Decode("dcDptDqlQv7tWIT2");

  var encryptedData =
      "7056BD62AF0A6D574A5B8BB1B0DA278BDD36B5EF529A14164CD7DB716E8556F3F8"
          .toUint8list();

  test('encrypt', () {
    var encrypted = Aes256GCM(iv).encrypt(data, key);
    expect(encrypted, encryptedData);
  });

  test('decrypt', () {
    var decrypted = Aes256GCM(iv).decrypt(encryptedData, key);
    expect(data, decrypted);
  });
}
