import 'package:chat_app/data/models/auth/sign_in_req.dart';
import 'package:chat_app/data/models/auth/sign_up_req.dart';
import 'package:chat_app/domain/repository/auth/auth.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<bool> signIn(SignInRequest signInReq) {
    // TODO: implement signIn
    throw UnimplementedError();
  }

  @override
  Future<bool> signUp(SignUpRequest singUpReq) {
    // TODO: implement signUp
    throw UnimplementedError();
  }
  
}