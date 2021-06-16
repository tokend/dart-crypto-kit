import 'dart:typed_data';

import 'package:pointycastle/key_derivators/scrypt.dart';
import 'package:pointycastle/pointycastle.dart';

/// Implements a classic scrypt KDF.
/// @see <a href="https://en.wikipedia.org/wiki/Scrypt">Scrypt in Wikipedia</a>
class ScryptKeyDerivation {
  int n, r, p;

  /// Creates [scrypt] instance with given params.
  /// [n] iterations count
  /// [r] block size
  /// [p] parallelization factor
  ScryptKeyDerivation(this.n, this.r, this.p);

  Uint8List derive(Uint8List passphrase, Uint8List salt, int keyLengthBytes) {
    var scryptParameters = ScryptParameters(n, r, p, keyLengthBytes, salt);

    var scrypt = Scrypt();
    scrypt.init(scryptParameters);
    Uint8List out = Uint8List(keyLengthBytes);

    scrypt.deriveKey(passphrase, 0, out, 0);
    return out;
  }
}
