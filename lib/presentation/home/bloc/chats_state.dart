import 'package:chat_app/data/models/chat/chat_and_user.dart';

abstract class ChatsState {}


class ChatsListInitial extends ChatsState  {}


class ChatsListLoaded extends ChatsState {
  final List<ChatAndUser> chats;

  ChatsListLoaded({required this.chats});
}

class ChatsListError extends ChatsState {}