import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BiometricAuthentication {
  static Future<bool> authenticateWithBiometrics() async {
    
    final LocalAuthentication localAuthentication = LocalAuthentication();
    bool isBiometricSupported = await localAuthentication.isDeviceSupported();
    bool canCheckBiometrics = await localAuthentication.canCheckBiometrics;
    print(isBiometricSupported); 
    print(canCheckBiometrics); 

    bool isAuthenticated = false;

    if (isBiometricSupported && canCheckBiometrics) {
      isAuthenticated = await localAuthentication.authenticate(
        localizedReason: 'Please complete the biometrics to proceed.',
        // useErrorDialogs: true,
        // stickyAuth: false
        // biometricOnly: true,
      );
    }

    return isAuthenticated;
  }
}