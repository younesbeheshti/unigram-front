import 'package:chat_app/data/models/auth/sign_in_req.dart';
import 'package:chat_app/data/models/auth/sign_up_req.dart';
import 'package:chat_app/data/sources/auth/auth_backend_service.dart';
import 'package:chat_app/domain/repository/auth/auth.dart';
import 'package:chat_app/service_locator.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<bool> signIn(SignInRequest signInReq) async {
    return await sl<AuthBackendService>().signIn(signInReq);
  }

  @override
  Future<bool> signUp(SignUpRequest singUpReq) async {
    return await sl<AuthBackendService>().signUp(singUpReq);
  }
  
}