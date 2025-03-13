import 'package:chat_app/core/usecase/usecase.dart';
import 'package:chat_app/domain/repository/user/user_repo.dart';
import 'package:chat_app/service_locator.dart';


class AddChatUseCase extends UseCase<int, int> {
  @override
  Future<int> call({int? params}) async{
    return await sl<UserRepository>().addChat(params!);
  }

}