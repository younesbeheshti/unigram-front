import 'package:chat_app/domain/entities/auth/user_entity.dart';
import 'package:chat_app/domain/entities/chat/chat_entity.dart';

class ChatModel {
  int? id;
  int? user1id;
  int? user2id;

  ChatModel({
    required this.id,
    required this.user1id,
    required this.user2id,
  });

  ChatModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user1id = json['username'];
    user2id = json['email'];
  }
}

extension ChatModelExt on ChatModel {
  ChatEntity toEntity() {
    return ChatEntity(
      id: id,
      user1id: user1id,
      user2id: user2id,
    );
  }
}
