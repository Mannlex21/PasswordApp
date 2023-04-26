import 'package:encrypt/encrypt.dart' as encrypt;

class UrlUtils {
  static String checkIfUrlContainPrefixHttp(String url) {
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    } else {
      return 'http://$url';
    }
  }
}
