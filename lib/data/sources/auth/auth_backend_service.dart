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
      final response = await http.post(
        Uri.parse("${AppUrls.baseURL}${AppUrls.login}"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
          {
            "username": signInReq.username,
            "password": signInReq.password,
          },
        ),
      );

      if (response.statusCode == 200) {
        print("login successful");
        final data = jsonDecode(response.body);

        print(data);

        final token = data["token"];
        final userId = data["userid"];

        await storage.write(key: "token", value: token);
        // print(userId);
        try {
          await storage.write(key: "userId", value: userId.toString());
        } catch (e) {
          print(e);
        }

        print("userid -> ${await storage.read(key: "userId")}");
        return true;
      } else {
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
      final response = await http.post(
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

      if (response.statusCode == 200) {
        print("signUp successful");

        final data = jsonDecode(response.body);
        print(data);
        final token = data["token"];
        final userId = data["userid"];

        await storage.write(key: "token", value: token);
        await storage.write(key: "userId", value: userId.toString());
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
