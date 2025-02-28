import 'package:chat_app/data/models/auth/sign_in_req.dart';
import 'package:chat_app/data/models/auth/sign_up_req.dart';


abstract class AuthRepository {
  Future<bool> signUp(SignUpRequest signUpReq);
  Future<bool> signIn(SignInRequest signInReq);
}