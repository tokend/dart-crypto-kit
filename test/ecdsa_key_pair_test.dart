import 'dart:typed_data';

import 'package:base16/base16.dart';
import 'package:dart_crypto_kit/crypto_ecdsa/ecdsa_key_pair.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  var privateKeySeed = new List.generate(32, (index) => index);
  Uint8List data = Uint8List.fromList('TokenD is awesome'.codeUnits);
  var dataSignature = base16decode(
      "B0B890056CCBA3B3188EFF742F581EC08F0540706C9AA83B2B669E58F5E488DD892FD543F9C9182F6E6CBA013D3953CADD2D9EDF2938A45918F063FCA01A0B0A");

  test('from private key seed', () async {
    var keyPair = await EcDSAKeyPair.fromPrivateKeySeed(privateKeySeed);
    expect(privateKeySeed, keyPair.privateKey);
  });

  test('random', () async {
    var keyPair1 = await EcDSAKeyPair.random();
    var privateKey1 = keyPair1.privateKey;

    var keyPair2 = await EcDSAKeyPair.random();
    var privateKey2 = keyPair2.privateKey;

    expect(privateKey1 != privateKey2, true);
  });

  test('verifyValid', () async {
    var keyPair = await EcDSAKeyPair.fromPrivateKeySeed(privateKeySeed);
    var isVerified =
        await EcDSAKeyPair.verify(data, dataSignature, keyPair.publicKey);
    expect(isVerified, true);
  });

  test('verifyInvalid', () async {
    var keyPair = await EcDSAKeyPair.fromPrivateKeySeed(privateKeySeed);
    var isVerified = await EcDSAKeyPair.verify(
        Uint8List(64), Uint8List(64), keyPair.publicKey);
    expect(isVerified, false);
  });

  test('sign', () async {
    var keyPair = await EcDSAKeyPair.fromPrivateKeySeed(privateKeySeed);
    var signature = await keyPair.sign(data);
    expect(signature, dataSignature);
  });

  test('destroy', () async {
    var keyPair = await EcDSAKeyPair.fromPrivateKeySeed(privateKeySeed);
    var privateKey = keyPair.privateKey;
    keyPair.destroy();
    expect(List.of(List.generate(privateKey.length, (index) => 0)), privateKey);
  });

  test('isDestroyedTrue', () async {
    var keyPair = await EcDSAKeyPair.fromPrivateKeySeed(privateKeySeed);
    keyPair.destroy();
    expect(keyPair.isDestroyed(), true);
  });

  test('isDestroyedFalse', () async {
    var keyPair = await EcDSAKeyPair.fromPrivateKeySeed(privateKeySeed);
    expect(keyPair.isDestroyed(), false);
  });
}