# TokenD Dart crypto kit

Crypto kit is a set of wrappers for third-party crypto libraries. It simplifies usage of crypto in TokenD-related projects by separating it's actual implementation.

## KDF

KDF module contains key derivation functions used in TokenD. It provides classical `scrypt` implementation and it's special modification used for [wallet ID and wallet key derivation](https://tokend.gitlab.io/docs/?http#wallet-id-derivation).

Based on [Pointy Castle](https://github.com/bcgit/pc-dart).

Usage example:
```dart
  int n = 4096;
  int r = 8;
  int p = 1;
  int keyLength = 32;

  var masterKey = Uint8List.fromList("WALLET_ID".codeUnits);
  var login = Uint8List.fromList("toma@tokend.org".codeUnits);
  var passphrase = Uint8List.fromList('qwe123'.codeUnits);
  var salt = base64Decode('67ufG1N/Rf+j2ugDaXaopw==');

  var walletId = ScryptWithMasterKeyDerivation(n, r, p, Uint8List.fromList("WALLET_ID".codeUnits), masterKey)
                         .derive(passphrase, salt, keyLength);

  var walletKey = ScryptWithMasterKeyDerivation(n, r, p, Uint8List.fromList("WALLET_KEY".codeUnits), masterKey)
                         .derive(passphrase, salt, keyLength);
```
