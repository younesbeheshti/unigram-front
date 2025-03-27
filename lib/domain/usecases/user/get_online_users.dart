import 'package:chat_app/core/usecase/usecase.dart';
import 'package:chat_app/domain/entities/auth/user_entity.dart';
import 'package:chat_app/domain/repository/user/user_repo.dart';
import 'package:chat_app/service_locator.dart';

class GetOnlineUsersUseCase extends UseCase<List<UserEntity>, dynamic> {
  @override
  Future<List<UserEntity>> call({dynamic params}) async {
    return await sl<UserRepository>().getOnlineUsers();
  }
}
