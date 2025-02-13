import 'package:chat_app/presentation/home/pages/home_page.dart';
import 'package:chat_app/presentation/auth/pages/signup.dart';
import 'package:flutter/material.dart';

class Signin extends StatelessWidget {
  Signin({super.key});

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Unigram"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          vertical: 50,
          horizontal: 30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _registerText(),
            SizedBox(
              height: 50,
            ),
            _userNameField(context),
            SizedBox(
              height: 15,
            ),
            _passwordField(context),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
            }, child: Text("SignIn"))
          ],
        ),
      ),
      bottomNavigationBar: _signUpText(context),
    );
  }

  Widget _registerText() {
    return Text(
      "Sign In",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 25,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _userNameField(BuildContext context) {
    return TextField(
      controller: _userNameController,
      decoration: InputDecoration(
        hintText: "Username",
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

  Widget _passwordField(BuildContext context) {
    return TextField(
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
        hintText: "Password",
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

  Widget _signUpText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Not A Member? ",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext builder) => Signup(),
                ),
              );
            },
            child: Text("Register Now"),
          ),
        ],
      ),
    );
  }
}
