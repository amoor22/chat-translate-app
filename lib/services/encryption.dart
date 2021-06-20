import 'dart:math';

class Encrypt {
  String text = '';
  int shift = 22;
  int multiplyBy = 2;

  Encrypt({this.text});

  String encrypt() {
    List<int> charCodes = new List();
    text.codeUnits.forEach((code) {
      charCodes.add((code * multiplyBy) + shift);
    });
    return String.fromCharCodes(charCodes);
  }

  String decrypt() {
    List<int> charCodes = new List();
    text.codeUnits.forEach((code) => charCodes.add((code - shift) ~/ multiplyBy));
    return String.fromCharCodes(charCodes);
  }
}

// each chat has it's own lock inside the messageCollection

class RsaEncrypt {
  String text = "test";
  List<int> encryptionKey = [5, 14];

  int encrypt() {
    List<int> charCode = new List();
    text.codeUnits.forEach((code) => charCode.add(code));
    for(int i = 0; i < charCode.length; i++) {
      // print(pow(charCode[i], encryptionKey[0]) % encryptionKey[1]);
    }
  }

  void generateKeys(int p, int q) {
    int n = p * q;
    int phiN = (p - 1) * (q - 1);
    // generating e
    Map<int, bool> nFactors = getFactors(n);
    Map<int, bool> phiFactors = getFactors(phiN);
    List<int> validE = new List();
    for(int i = 2; i < phiN; i++) {
      Map<int, bool> iFactors = getFactors(i);
      bool co = true;
      iFactors.forEach((key, value) {
        if(phiFactors[key] == true || nFactors[key] == true) {
          co = false;
        }
      });
      if(co) {
        validE.add(i);
      }
      // if(nFactors[i] == null && phiFactors[i] == null && i % 2 != 0) {
      // }
    }
    int e = validE[Random().nextInt(validE.length)];
    
    int d = ((phiN * 1) - 1);
    print((d*e) % phiN);
    //phi function to calculate the number of coprime factors of a given number
    //iow numbers from 1 - x that don't share common factors with x
  }

  Map<int, bool> getFactors(int num) {
    Map<int, bool> factors = new Map();
    for(int i = 2; i <= num; i++) {
      if(num % i == 0) {
        factors[i] = true;
      }
    }
    return factors;
  }

}