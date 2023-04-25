import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';
import 'package:local_auth/error_codes.dart' as local_auth_error;

class LocalAuth {
  static final _auth = LocalAuthentication();

  static Future<bool> _canAuthenticate() async =>
      await _auth.canCheckBiometrics || await _auth.isDeviceSupported();

  static Future<bool> authenticate() async {
    try {
      if (!await _canAuthenticate()) return false;
      return await _auth.authenticate(
          localizedReason: 'Por favor, confirma tu identidad para continuar.',
          authMessages: const <AuthMessages>[
            AndroidAuthMessages(
              signInTitle: 'Portapapeles bloqueado',
              cancelButton: 'No gracias',
            ),
            IOSAuthMessages(
              cancelButton: 'No gracias',
            ),
          ],
          options: const AuthenticationOptions(
              useErrorDialogs: true, stickyAuth: true));
    } on PlatformException catch (e) {
      if (e.code == local_auth_error.notAvailable) {
        debugPrint('warning: $e');
        return true;
      } else {
        debugPrint('error: $e');
        return false;
      }
    }
  }
}
