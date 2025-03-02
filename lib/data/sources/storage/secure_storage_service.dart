import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {

  final FlutterSecureStorage _storage;

  SecureStorageService(this._storage);

  // functions to return the storage
  // Future<FlutterSecureStorage> getStorage() async =>await  _storage;

  Future<void> write({String? key, dynamic value}) async {
    await _storage.write(key: key!, value: value);
  }

  Future<dynamic> read({String? key}) async {
    return await _storage.read(key: key!);
  }

  Future<void> delete({String? key}) async {
    await _storage.delete(key: key!);
  }

  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}