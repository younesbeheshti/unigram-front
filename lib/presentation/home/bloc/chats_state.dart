import 'package:chat_app/domain/entities/chat/chat_entity.dart';

abstract class ChatsState {}


class ChatsListInitial extends ChatsState  {}


class ChatsListLoaded extends ChatsState {
  final List<ChatEntity> chats;

  ChatsListLoaded({required this.chats});
}

class ChatsListError extends ChatsState {}