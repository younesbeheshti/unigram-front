import 'package:chat_app/core/usecase/usecase.dart';
import 'package:chat_app/domain/entities/chat/chat_entity.dart';
import 'package:chat_app/domain/repository/user/user_repo.dart';
import 'package:chat_app/service_locator.dart';

class UserChatsUseCase extends UseCase<List<ChatEntity>, dynamic> {
  @override
  Future<List<ChatEntity>> call({dynamic params}) async {
    return await sl<UserRepository>().getChats();
  }
}
