import 'package:chat_app/core/usecase/usecase.dart';
import 'package:chat_app/data/models/auth/sign_in_req.dart';
import 'package:chat_app/domain/repository/auth/auth.dart';
import 'package:chat_app/service_locator.dart';

class SignInUseCase extends UseCase<bool, SignInRequest>{
  @override
  Future<bool> call({SignInRequest? params}) async {
    return sl<AuthRepository>().signIn(params!);
  }
}