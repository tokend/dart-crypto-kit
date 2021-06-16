import 'dart:typed_data';

extension IntToHex on int {
  hex() {
    if (this >= '0'.codeUnitAt(0) && this <= '9'.codeUnitAt(0)) {
      return this - '0'.codeUnitAt(0);
    } else if (this >= 'A'.codeUnitAt(0) && this <= 'F'.codeUnitAt(0)) {
      return (this - 'A'.codeUnitAt(0)) + 10;
    }
  }
}

extension Uint8ToListToHex on Uint8List {
  hex() {
    int length;
    if (this == null || (length = this.length) <= 0) {
      return "";
    }
    Uint8List result = new Uint8List(length << 1);
    int i = 0;
    for (int j = 0; j < length; j++) {
      int k = i + 1;
      var valuesArray = [
        '0',
        '1',
        '2',
        '3',
        '4',
        '5',
        '6',
        '7',
        '8',
        '9',
        'a',
        'b',
        'c',
        'd',
        'e',
        'f'
      ];

      var index = (this[j] >> 4) & 15;
      result[i] = valuesArray[index].codeUnitAt(0);
      i = k + 1;
      result[k] = valuesArray[this[j] & 15].codeUnitAt(0);
    }
    return new String.fromCharCodes(result);
  }
}

extension StringToUint8List on String {
  Uint8List toUint8list() {
    int length = this.length;
    var string = this;
    if (length % 2 != 0) {
      string = '0' + string;
      length++;
    }
    List<int> s = string.toUpperCase().codeUnits;
    Uint8List bArr = Uint8List(length >> 1);
    for (int i = 0; i < length; i += 2) {
      bArr[i >> 1] = ((s[i].hex() << 4) | s[i + 1].hex());
    }
    return bArr;
  }
}
