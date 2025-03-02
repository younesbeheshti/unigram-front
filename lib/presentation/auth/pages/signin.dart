import 'package:chat_app/data/models/auth/sign_in_req.dart';
import 'package:chat_app/domain/usecases/auth/sign_in.dart';
import 'package:chat_app/presentation/home/pages/home_page.dart';
import 'package:chat_app/presentation/auth/pages/signup.dart';
import 'package:chat_app/service_locator.dart';
import 'package:flutter/material.dart';

class Signin extends StatelessWidget {
  Signin({super.key});

  final TextEditingController _usernameController = TextEditingController();
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
            _usernameField(context),
            SizedBox(
              height: 15,
            ),
            _passwordField(context),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () async {
                  var isValid = await sl<SignInUseCase>().call(
                    params: SignInRequest(
                      username: _usernameController.text,
                      password: _passwordController.text,
                    ),
                  );

                  if (isValid) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Invalid Credentials"),
                      ),
                    );
                  }
                },
                child: Text("SignIn"))
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

  Widget _usernameField(BuildContext context) {
    return TextField(
      controller: _usernameController,
      decoration: InputDecoration(
        hintText: "username",
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
