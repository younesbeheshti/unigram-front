import 'dart:convert';

import 'package:chat_app/core/configs/constants/app_url.dart';
import 'package:chat_app/data/models/auth/sign_in_req.dart';
import 'package:chat_app/data/models/auth/sign_up_req.dart';
import 'package:chat_app/data/sources/storage/secure_storage_service.dart';
import 'package:chat_app/service_locator.dart';
import "package:http/http.dart" as http;

abstract class AuthBackendService {
  Future<bool> signIn(SignInRequest signInReq);

  Future<bool> signUp(SignUpRequest singUpReq);
}

class AuthBackendServiceImpl implements AuthBackendService {

  final storage = sl<SecureStorageService>();

  @override
  Future<bool> signIn(SignInRequest signInReq) async {
    try {
      final resposne = await http.post(
        Uri.parse("${AppUrls.baseURL}${AppUrls.login}"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
          {
            "email": signInReq.email,
            "password": signInReq.password,
          },
        ),
      );


      if (resposne.statusCode == 200) {
        print("login successful");
        final data = jsonDecode(resposne.body);
        final token = data["token"];
        final userId = data["userId"];

        await storage.write(key: "token", value: token);
        await storage.write(key: "userId", value: userId);

        return true;
      }else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<bool> signUp(SignUpRequest singUpReq) async {
    try {
      final resposne = await http.post(
        Uri.parse("${AppUrls.baseURL}${AppUrls.register}"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
          {
            "username": singUpReq.username,
            "email": singUpReq.email,
            "password": singUpReq.password,
          },
        ),
      );

      if (resposne.statusCode == 200) {
        print("signUp successful");

        final data = jsonDecode(resposne.body);
        final token = data["token"];
        final userId = data["userId"];

        await storage.write(key: "token", value: token);
        await storage.write(key: "userId", value: userId);
        return true;
      }else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
