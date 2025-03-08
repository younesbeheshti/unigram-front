import 'package:chat_app/core/usecase/usecase.dart';
import 'package:chat_app/domain/repository/user/user_repo.dart';
import 'package:chat_app/service_locator.dart';

import '../../entities/auth/user_entity.dart';

class AddChatUseCase extends UseCase<int, UserEntity> {
  @override
  Future<int> call({UserEntity? params}) async{
    return await sl<UserRepository>().addChat(params!);

  }

}