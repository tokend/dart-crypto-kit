import 'dart:typed_data';

import 'package:pointycastle/api.dart';
import 'package:pointycastle/block/aes_fast.dart';
import 'package:pointycastle/block/modes/gcm.dart';

///Represents AES-256-GCM cipher.
class Aes256GCM {
  Uint8List iv;

  /// Creates AES-256-GCM cipher initialized with given IV.
  /// [iv] is non-empty byte array of initialization vector
  Aes256GCM(Uint8List iv) {
    if (iv.length == 0) {
      throw ArgumentError("IV must be at least 1 byte");
    }

    this.iv = iv;
  }

  ///Encrypts data with given 128/192/256 bits key.
  Uint8List encrypt(Uint8List data, Uint8List key) {
    return applyCipher(data, key, false);
  }

  /// Decrypts cipher text with given 128/192/256 bits key.
  /// @throws [InvalidCipherTextException] if cipher text is invalid in some way
  Uint8List decrypt(Uint8List cipherText, Uint8List key) {
    try {
      return applyCipher(cipherText, key, true);
    } on InvalidCipherTextException {

      throw InvalidCipherTextException;
    }
  }

  Uint8List applyCipher(Uint8List data, Uint8List key, bool isDecrypt) {
    var cipher = GCMBlockCipher(AESFastEngine());
    cipher.init(!isDecrypt, ParametersWithIV(KeyParameter(key), iv));

    var out = Uint8List(cipher.getOutputSize(data.length));
    var processed = cipher.processBytes(data, 0, data.lengthInBytes, out, 0);
    processed += cipher.doFinal(out, processed);
    var result =  out.sublist(0, processed);
    out.fillRange(0, out.length, 0);
    return result;
  }
}