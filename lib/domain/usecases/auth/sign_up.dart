import 'package:chat_app/core/usecase/usecase.dart';
import 'package:chat_app/data/models/auth/sign_up_req.dart';
import 'package:chat_app/domain/repository/auth/auth.dart';
import 'package:chat_app/service_locator.dart';

class SignUpUseCase extends UseCase<bool, SignUpRequest> {
  @override
  Future<bool> call({SignUpRequest? params}) async{
    return sl<AuthRepository>().signUp(params!);
  }

}