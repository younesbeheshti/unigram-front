import 'package:chat_app/data/sources/user/user_backend_service.dart';
import 'package:chat_app/domain/repository/user/user_repo.dart';
import 'package:chat_app/service_locator.dart';

class UserRepositoryImpl implements UserRepository {
  @override
  Future<List> getContacts() async {
    return await sl<UserBackendService>().getContacts();
  }

  @override
  Future<void> getUserInfo() async {
    return await sl<UserBackendService>().getUserInfo();
  }

}