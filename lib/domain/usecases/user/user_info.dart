import 'package:chat_app/core/usecase/usecase.dart';
import 'package:chat_app/domain/repository/user/user_repo.dart';
import 'package:chat_app/service_locator.dart';

class UserInfoUseCase extends UseCase<void, dynamic>{
  @override
  Future<void> call({params}) async {
    return await sl<UserRepository>().getUserInfo();
  }
}