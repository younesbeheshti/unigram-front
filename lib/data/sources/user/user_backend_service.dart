import "dart:convert";

import "package:chat_app/data/sources/storage/secure_storage_service.dart";
import "package:chat_app/service_locator.dart";
import "package:http/http.dart" as http;

import "../../../core/configs/constants/app_url.dart";

abstract class UserBackendService {
  Future<void> getUserInfo();

  Future<List> getContacts();
}

class UserBackendServiceImpl implements UserBackendService {
  final storage = sl<SecureStorageService>();

  @override
  Future<List> getContacts() async {
    try {
      final token = await storage.read(key: "token");
      final userId = await storage.read(key: "userId");
      final response = await http.get(
        Uri.parse("${AppUrls.baseURL}${AppUrls.contacts}/$userId"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data["contacts"]);
        return data["contacts"];
      } else {
        return [];
      }

    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Future<void> getUserInfo() {
    // TODO: implement getUserInfo
    throw UnimplementedError();
  }
}
