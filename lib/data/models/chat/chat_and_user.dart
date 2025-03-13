import 'package:chat_app/domain/entities/chat/chat_entity.dart';

class ChatAndUser {
  final String chatName;
  final ChatEntity chatEntity;

  ChatAndUser({
    required this.chatName,
    required this.chatEntity,
  });
}
