import 'package:chat_app/core/usecase/usecase.dart';
import 'package:chat_app/domain/repository/user/user_repo.dart';
import 'package:chat_app/service_locator.dart';

class UserContactsUseCase extends UseCase<List, dynamic> {
  @override
  Future<List> call({params}) async {
    return await sl<UserRepository>().getContacts();
  }
}
