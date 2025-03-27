import 'package:chat_app/data/sources/user/user_backend_service.dart';
import 'package:chat_app/domain/entities/auth/user_entity.dart';
import 'package:chat_app/domain/entities/chat/chat_entity.dart';
import 'package:chat_app/domain/entities/message/message_entity.dart';
import 'package:chat_app/domain/repository/user/user_repo.dart';
import 'package:chat_app/service_locator.dart';

class UserRepositoryImpl implements UserRepository {
  @override
  Future<List<UserEntity>> getContacts() async {
    return await sl<UserBackendService>().getContacts();
  }

  @override
  Future<void> getUserInfo() async {
    return await sl<UserBackendService>().getUserInfo();
  }

  @override
  Future<List<ChatEntity>> getChats() async {
    return await sl<UserBackendService>().getChats();
  }

  @override
  Future<int> addChat(int user2id) async{
    return await sl<UserBackendService>().addChat(user2id);
  }

  @override
  Future<List<MessageRequest>> getChatMessages(int chatId) async {
    return await sl<UserBackendService>().getChatMessages(chatId);
  }

  @override
  Future<List<UserEntity>> getOnlineUsers() async{
    return await sl<UserBackendService>().getOnlineUsers();
  }




}