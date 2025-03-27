import 'package:chat_app/domain/entities/auth/user_entity.dart';
import 'package:chat_app/domain/entities/chat/chat_entity.dart';
import 'package:chat_app/domain/entities/message/message_entity.dart';

abstract class UserRepository {

  Future<void> getUserInfo();
  Future<List<UserEntity>> getContacts();
  Future<List<ChatEntity>> getChats();
  Future<int> addChat(int user2id);
  Future<List<MessageRequest>> getChatMessages(int chatId);

}