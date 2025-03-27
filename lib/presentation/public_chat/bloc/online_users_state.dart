import 'package:chat_app/domain/entities/auth/user_entity.dart';

abstract class OnlineUsersState {}


class OnlineUsersInitial extends OnlineUsersState {}

class OnlineUsersLoaded extends OnlineUsersState {
  final List<UserEntity> onlineUsers;

  OnlineUsersLoaded({required this.onlineUsers});
}

class OnlineUsersError extends OnlineUsersState {}