import 'package:chat_app/domain/entities/auth/user_entity.dart';

abstract class ContactsState {}


class ContactsInitial extends ContactsState {}

class ContactsLoaded extends ContactsState {
  final List<UserEntity> contacts;

  ContactsLoaded({required this.contacts});
}

class ContactsError extends ContactsState {}