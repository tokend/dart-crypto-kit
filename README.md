# TokenD Dart crypto kit

Crypto kit is a set of wrappers for third-party crypto libraries. It simplifies usage of crypto in TokenD-related projects by separating it's actual implementation.
##Cipher

Cipher module contains ciphers required for TokenD. Currently the only used cipher is `AES-256-GCM`.

Based on [Pointy Castle](https://github.com/bcgit/pc-dart).

Usage example:
```dart
List<int> dataList = 'TokenD is awesome'.codeUnits;

  Uint8List data = Uint8List.fromList(dataList);
  var key = "2e0c7a28545d4c53a1f4b9ef82245d7da853c7f0b0ae949040faedaa60c23c0b"
      .toUint8list();
  var iv = base64Decode("dcDptDqlQv7tWIT2");

  var encryptedData = Aes256GCM(iv).encrypt(data, key);
```

##EcDSA

EcDSA module contains elliptic curve cryptography used in TokenD. It provides signing on `Ed25519` curve with `SHA-256` hashing.

Usage example:
```dart
Uint8List data = Uint8List.fromList('TokenD is awesome'.codeUnits);
var keyPair = EcDSAKeyPair.random();
var signature = keyPair.sign(data);
var isVerified = EcDSAKeyPair.verify(data, signature, keyPair.publicKey);
```

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