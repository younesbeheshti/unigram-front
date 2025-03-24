import 'package:chat_app/data/models/chat/chat_and_user.dart';
import 'package:chat_app/data/sources/storage/secure_storage_service.dart';
import 'package:chat_app/domain/entities/auth/user_entity.dart';
import 'package:chat_app/domain/entities/chat/chat_entity.dart';
import 'package:chat_app/domain/repository/user/user_repo.dart';
import 'package:chat_app/presentation/home/bloc/chats_state.dart';
import 'package:chat_app/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatsCubit extends Cubit<ChatsState> {
  ChatsCubit() : super(ChatsListInitial());

  Future<void> getChats() async {
    List<ChatEntity> chats = await sl<UserRepository>().getChats();
    List<UserEntity> contacts = await sl<UserRepository>().getContacts();
    final int userId = int.parse(await sl<SecureStorageService>().read(key: "userId"));

    Map<int, UserEntity> userMap = {for (var user in contacts) user.id!: user};

    List<ChatAndUser> chatUsers = chats.map((chat) {
      int chatUser1 = chat.user1id!;
      int chatUser2 = chat.user2id!;

      if (chatUser1 != userId) {
        int temp = chatUser1;
        chatUser1 = chatUser2;
        chatUser2 = temp;
      }

      UserEntity? user = userMap[chatUser2];

      return ChatAndUser(
        chatName: user?.username ?? "Unknown",
        chatEntity: ChatEntity(
          id: chat.id,
          user1id: chatUser1,
          user2id: chatUser2,
        ),
      );
    }).toList();

    emit(ChatsListLoaded(chats: chatUsers));
  }
}


