import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:cryptography/helpers.dart';

class EcDSAKeyPair {
  static final algorithm = Ed25519();
  SimplePublicKey publicKey;
  List<int> privateKey;
  Uint8List seed;

  EcDSAKeyPair(this.publicKey, this.privateKey, this.seed);

  /// Creates keypair from given 32 byte seed for given curve.
  /// Original seed will be duplicated.
  static Future<EcDSAKeyPair> fromPrivateKeySeed(List<int> seed) async {
    var keyPair = await algorithm.newKeyPairFromSeed(seed);
    var pubKey = await keyPair.extractPublicKey();
    var privateKey = await keyPair.extractPrivateKeyBytes();
    return EcDSAKeyPair(
        pubKey, Uint8List.fromList(privateKey), Uint8List.fromList(seed));
  }

  ///Creates keypair for given curve with random keys.
  static Future<EcDSAKeyPair> random() async {
    var seed = Uint8List(32);
    fillBytesWithSecureRandom(seed);
    var keyPair = await algorithm.newKeyPairFromSeed(seed);
    var pubKey = await keyPair.extractPublicKey();
    var privateKey = await keyPair.extractPrivateKeyBytes();
    return EcDSAKeyPair(pubKey, privateKey, seed);
  }

  /// Signs given data with private key if keypair has it
  static Future<List> sign(Uint8List data, List<int> seed) async {
    var keyPair = await algorithm.newKeyPairFromSeed(seed);
    var signature = await algorithm.sign(data.toList(), keyPair: keyPair);

    return signature.bytes;
  }

  ///Destroys keypair's private key by filling it content with zeros
  destroy() {
    privateKey.fillRange(0, privateKey.length, 0);
    seed.fillRange(0, seed.length, 0);
    privateKey = null;
  }

  ///Returns [true] if keypair private key is destroyed
  ///
  ///See [EcDSAKeyPair.destroy]
  bool isDestroyed() {
    return privateKey == null;
  }

  /// Verifies signature for provided data with public key
  /// @return [true] if the signature is valid, [false] otherwise
  Future<bool> verify(Uint8List data, List<int> signature) async {
    return algorithm.verify(data.toList(),
        signature: Signature(signature, publicKey: publicKey));
  }
}