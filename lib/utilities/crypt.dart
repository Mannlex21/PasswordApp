import 'package:encrypt/encrypt.dart' as encrypt;

class Crypt {
  static dynamic encryptString(String value) {
    final key = encrypt.Key.fromUtf8('%C*F-JaNdRgUkXp2s5v8y/A?D(G+KbPe');
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(value, iv: iv);

    return encrypted;
  }

  static dynamic decryptedString(String value) {
    final key = encrypt.Key.fromUtf8('%C*F-JaNdRgUkXp2s5v8y/A?D(G+KbPe');
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final decrypted =
        encrypter.decrypt(encrypt.Encrypted.fromBase64(value), iv: iv);
    return decrypted;
  }
}
