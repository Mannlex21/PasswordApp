import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:encrypt/encrypt.dart';

class Crypt {
  static Encrypted encryptString(String value) {
    final key = encrypt.Key.fromUtf8('%C*F-JaNdRgUkXp2s5v8y/A?D(G+KbPe');
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(value, iv: iv);

    return encrypted;
  }

  static String decryptedString(String value) {
    final key = encrypt.Key.fromUtf8('%C*F-JaNdRgUkXp2s5v8y/A?D(G+KbPe');
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final decrypted =
        encrypter.decrypt(encrypt.Encrypted.fromBase64(value), iv: iv);
    return decrypted;
  }
}
