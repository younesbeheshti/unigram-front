import 'package:chat_app/pages/chat_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // List Users = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Chat App"),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage()));
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10)),
              height: 70,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                      child: Text("Name"),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => SizedBox(height: 10),
        itemCount: 3,
      ),
    );
  }
}
