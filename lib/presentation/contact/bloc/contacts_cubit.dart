import 'package:chat_app/domain/entities/auth/user_entity.dart';
import 'package:chat_app/domain/repository/user/user_repo.dart';
import 'package:chat_app/presentation/contact/bloc/contacts_state.dart';
import 'package:chat_app/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactsCubit extends Cubit<ContactsState> {
  ContactsCubit() : super(ContactsInitial());

  Future<void> getContacts() async {
    List<UserEntity> contacts = await sl<UserRepository>().getContacts();

    if (contacts.isNotEmpty) {
      emit(ContactsLoaded(contacts: contacts));
    }else {
      emit(ContactsError());
    }

  }
}