import 'package:chat_app/domain/entities/auth/user_entity.dart';
import 'package:chat_app/domain/repository/user/user_repo.dart';
import 'package:chat_app/presentation/contact/bloc/contacts_state.dart';
import 'package:chat_app/presentation/public_chat/bloc/online_users_state.dart';
import 'package:chat_app/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnlineUsersCubit extends Cubit<OnlineUsersState> {
  OnlineUsersCubit() : super(OnlineUsersInitial());

  Future<void> getOnlineUsers() async {
    List<UserEntity> onlineUsers = await sl<UserRepository>().getOnlineUsers();

    if (onlineUsers.isNotEmpty) {
      emit(OnlineUsersLoaded(onlineUsers: onlineUsers));
    }else {
      emit(OnlineUsersError());
    }

  }
}