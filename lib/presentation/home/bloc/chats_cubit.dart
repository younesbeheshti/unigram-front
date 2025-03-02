import 'package:chat_app/domain/entities/chat/chat_entity.dart';
import 'package:chat_app/domain/repository/user/user_repo.dart';
import 'package:chat_app/presentation/home/bloc/chats_state.dart';
import 'package:chat_app/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatsCubit extends Cubit<ChatsState> {
  ChatsCubit() : super(ChatsListInitial());

  Future<void> getChats() async {
    List<ChatEntity> chats = await sl<UserRepository>().getChats();

    if (chats.isNotEmpty) {
      emit(ChatsListLoaded(chats: chats));
    }else {
      emit(ChatsListError());
    }

  }

}
