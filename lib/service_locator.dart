
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import 'data/sources/storage/secure_storage_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerSingleton<FlutterSecureStorage>(FlutterSecureStorage());

  sl.registerSingleton<SecureStorageService>(
    SecureStorageService(sl<FlutterSecureStorage>()),
  );
}