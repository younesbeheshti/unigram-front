import 'package:chat_app/domain/entities/auth/user_entity.dart';

class UserModel {
  String? id;
  String? username;
  String? email;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
  }
}

extension UserModelExt on UserModel {
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      username: username,
      email: email,
    );
  }
}
