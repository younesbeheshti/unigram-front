import 'dart:io';

import 'package:chat_app/data/ws/client.dart';
import 'package:chat_app/presentation/chat/pages/chat_page.dart';
import 'package:chat_app/presentation/contact/pages/contact.dart';
import 'package:chat_app/service_locator.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List Users = [];

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
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListView.separated(
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {

                // Todo: send the receiver id

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(receiverId: 1,),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                        child: Text("server"),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => SizedBox(height: 10),
          itemCount: 1,
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
}
