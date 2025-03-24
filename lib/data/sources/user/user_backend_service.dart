import "dart:convert";

import "package:chat_app/data/models/chat/chat_model.dart";
import "package:chat_app/data/models/user/user_model.dart";
import "package:chat_app/data/sources/storage/secure_storage_service.dart";
import "package:chat_app/domain/entities/auth/user_entity.dart";
import "package:chat_app/domain/entities/chat/chat_entity.dart";
import "package:chat_app/domain/entities/message/message_entity.dart";
import "package:chat_app/service_locator.dart";
import "package:http/http.dart" as http;

import "../../../core/configs/constants/app_url.dart";

abstract class UserBackendService {
  Future<void> getUserInfo();

  Future<List<UserEntity>> getContacts();

  Future<List<ChatEntity>> getChats();

  Future<int> addChat(int user2id);

  Future<List<MessageRequest>> getChatMessages(int chatId);
}

class UserBackendServiceImpl implements UserBackendService {
  final storage = sl<SecureStorageService>();

  @override
  Future<List<UserEntity>> getContacts() async {
    try {
      List<UserEntity> contacts = [];

      final token = await storage.read(key: "token");

      final response = await http.get(
        Uri.parse("${AppUrls.baseURL}${AppUrls.contacts}"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        for (var contact in data["contacts"]) {
          var userModel = UserModel.fromJson(contact);
          contacts.add(userModel.toEntity());
        }

        return contacts;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Future<void> getUserInfo() async {
    try {
      final token = await storage.read(key: "token");
      final userId = await storage.read(key: "userId");
      final response = await http.get(
        Uri.parse("${AppUrls.baseURL}${AppUrls.userInfo}/$userId"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<List<ChatEntity>> getChats() async {
    try {
      List<ChatEntity> chats = [];

      final token = await storage.read(key: "token");

      final response = await http.get(
        Uri.parse("${AppUrls.baseURL}${AppUrls.chats}"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        print("getting chats");
        final data = jsonDecode(response.body);
        print(data["chat"]);
        for (var chat in data["chat"]) {
          var chatModel = ChatModel.fromJson(chat);
          chats.add(chatModel.toEntity());
        }

        return chats;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Future<int> addChat(int user2id) async {
    try {
      final token = await storage.read(key: "token");
      final userId = await storage.read(key: "userId");
      final response = await http.post(
        Uri.parse("${AppUrls.baseURL}${AppUrls.addChat}"),
        headers: {
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(
          {
            "user1id": int.parse(userId),
            "user2id": user2id,
          },
        ),
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("addchat -> $data");
        return data["chat_id"];
      } else {
        return 0;
      }
    } catch (e) {
      print(e);
      return 0;
    }
  }

  @override
  Future<List<MessageRequest>> getChatMessages(int chatId) async {
    try {
      final token = await storage.read(key: "token");

      final response = await http.get(
        Uri.parse("${AppUrls.baseURL}${AppUrls.messages}/$chatId"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("get chats -> $data"); // Debug: print full response

        if (data is! Map ||
            !data.containsKey("messages") ||
            data["messages"] is! List) {
          print("Invalid response format!"); // Debug
          return [];
        }

        List<MessageRequest> messages = data["messages"]
            .map<MessageRequest>((message) => MessageRequest.fromJson(message))
            .toList();

        print("Parsed messages count: ${messages.length}");
        return messages;
      } else {
        print("sad bob ros");
        return [];
      }
    } catch (e) {
      print("sad younes");
      print(e);
      return [];
    }
  }
}
