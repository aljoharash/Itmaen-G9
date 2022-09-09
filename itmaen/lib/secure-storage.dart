import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  
  static final _secureStorage =  FlutterSecureStorage();



 Future<void> writeSecureData(String key_ , String? value_) async {
 await _secureStorage.write(key: key_ , value: value_);
}



Future<String?> readSecureData(String key_) async {
 var readData =await _secureStorage.read(key: key_);
 return readData;
}

Future<void> deleteSecureData(String key_) async {
 await _secureStorage.delete(key: key_);
}
}
