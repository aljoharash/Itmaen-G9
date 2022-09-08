import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
 final _secureStorage = const FlutterSecureStorage();



 Future<void> writeSecureData(String key , String? value) async {
 await _secureStorage.write(key: key , value: value);
}



Future<String?> readSecureData(String key) async {
 var readData =
     await _secureStorage.read(key: key);
 return readData;
}
}