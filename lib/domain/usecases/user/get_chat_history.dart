import 'package:chat_app/core/usecase/usecase.dart';
import 'package:chat_app/domain/entities/message/message_entity.dart';
import 'package:chat_app/domain/repository/user/user_repo.dart';
import 'package:chat_app/service_locator.dart';


class GetChatMessagesUseCase extends UseCase<List<MessageRequest>, int> {
  @override
  Future<List<MessageRequest>> call({int? params}) async{
    return await sl<UserRepository>().getChatMessages(params!);
  }

}