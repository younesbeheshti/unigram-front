import 'package:chat_app/data/sources/storage/secure_storage_service.dart';
import 'package:chat_app/domain/repository/user/user_repo.dart';
import 'package:chat_app/presentation/chat/pages/chat_page.dart';
import 'package:chat_app/presentation/contact/bloc/contacts_cubit.dart';
import 'package:chat_app/presentation/contact/bloc/contacts_state.dart';
import 'package:chat_app/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _contactList(),
          ],
        ),
      ),
    );
  }

  Widget _contactList() {
    return BlocProvider(
      create: (context) => ContactsCubit()..getContacts(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 20,
            ),
            BlocBuilder<ContactsCubit, ContactsState>(
              builder: (context, state) {
                if (state is ContactsInitial) {
                  return Center(child: CircularProgressIndicator());
                }

                if (state is ContactsLoaded) {
                  if (state.contacts.isEmpty) {
                    return Center(
                      child: Text("NO CONTACT"),
                    );
                  }

                  return Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Divider(
                          height: 0.2,
                        ),
                      ),
                      itemCount: state.contacts.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {

                            int chatId = await sl<UserRepository>().addChat(state.contacts[index].id!);
                            int senderId = int.parse(await sl<SecureStorageService>().read(key: "userId"));
                            print("chat id -> $chatId");
                            print("senderid -> $senderId");



                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatPage(
                                  chatId: chatId,
                                  title: state.contacts[index].username,
                                  receiverId: state.contacts[index].id!,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[100],
                            ),
                            height: 70,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 5),
                              child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    decoration: BoxDecoration(
                                      // image:
                                      color: Colors.deepPurple,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Container(
                                    child:
                                        Text(state.contacts[index].username!),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }

                if (state is ContactsError) {
                  return Center(child: Text("Error"));
                }

                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
