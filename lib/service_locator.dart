import 'package:chat_app/data/repository/auth/auth_repository_impl.dart';
import 'package:chat_app/data/repository/user/user_repo_impl.dart';
import 'package:chat_app/data/sources/auth/auth_backend_service.dart';
import 'package:chat_app/data/sources/user/user_backend_service.dart';
import 'package:chat_app/data/ws/client.dart';
import 'package:chat_app/domain/repository/auth/auth.dart';
import 'package:chat_app/domain/repository/user/user_repo.dart';
import 'package:chat_app/domain/usecases/auth/sign_in.dart';
import 'package:chat_app/domain/usecases/auth/sign_up.dart';
import 'package:chat_app/domain/usecases/user/get_online_users.dart';
import 'package:chat_app/domain/usecases/user/user_chats.dart';
import 'package:chat_app/domain/usecases/user/user_contacts.dart';
import 'package:chat_app/domain/usecases/user/user_info.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import 'data/sources/storage/secure_storage_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerSingleton<FlutterSecureStorage>(
    FlutterSecureStorage(),
  );

  sl.registerSingleton<SecureStorageService>(
    SecureStorageService(sl<FlutterSecureStorage>()),
  );

  sl.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(),
  );

  sl.registerSingleton<AuthBackendService>(
    AuthBackendServiceImpl(),
  );

  sl.registerSingleton<UserRepository>(
    UserRepositoryImpl(),
  );

  sl.registerSingleton<UserBackendService>(
    UserBackendServiceImpl(),
  );

  sl.registerSingleton<SignUpUseCase>(
    SignUpUseCase(),
  );

  sl.registerSingleton<SignInUseCase>(
    SignInUseCase(),
  );

  sl.registerSingleton<UserInfoUseCase>(
    UserInfoUseCase(),
  );

  sl.registerSingleton<UserContactsUseCase>(
    UserContactsUseCase(),
  );

  sl.registerSingleton<UserChatsUseCase>(
    UserChatsUseCase(),
  );

  sl.registerSingleton<WebSocketClient>(
    WebSocketClient(),
  );

  sl.registerSingleton<GetOnlineUsersUseCase>(
    GetOnlineUsersUseCase()
  );
}
