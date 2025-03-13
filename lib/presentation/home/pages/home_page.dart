import 'package:chat_app/data/ws/client.dart';
import 'package:chat_app/domain/repository/user/user_repo.dart';
import 'package:chat_app/presentation/chat/pages/chat_page.dart';
import 'package:chat_app/presentation/contact/pages/contact.dart';
import 'package:chat_app/presentation/home/bloc/chats_cubit.dart';
import 'package:chat_app/presentation/home/bloc/chats_state.dart';
import 'package:chat_app/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    sl<WebSocketClient>().connect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Unigram"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _chats(context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Contact()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  Widget _chats(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatsCubit()..getChats(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocBuilder<ChatsCubit, ChatsState>(
              builder: (context, state) {
                if (state is ChatsListInitial) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is ChatsListLoaded) {
                  if (state.chats.isEmpty) {
                    return Center(
                      child: Text("NO Chats yet..."),
                    );
                  }

                  return Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatPage(
                                  chatId: state.chats[index].chatEntity.id!,
                                  title: state.chats[index].chatName,
                                  receiverId: state.chats[index].chatEntity.user2id!,
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
                                  vertical: 10, horizontal: 10),
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
                                    child: Text(state.chats[index].chatName),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Divider(
                          height: 0.2,
                        ),
                      ),
                      itemCount: state.chats.length,
                    ),
                  );
                }

                if (state is ChatsListError ){
                  return Center(child: Text("Check your internet connection"));
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
