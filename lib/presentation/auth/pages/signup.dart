import 'package:chat_app/data/models/auth/sign_up_req.dart';
import 'package:chat_app/domain/usecases/auth/sign_up.dart';
import 'package:chat_app/presentation/home/pages/home_page.dart';
import 'package:chat_app/presentation/auth/pages/signin.dart';
import 'package:chat_app/service_locator.dart';
import 'package:flutter/material.dart';

class Signup extends StatelessWidget {
  Signup({super.key});

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Unigram"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 50,
          horizontal: 30,
        ),
        child: Container(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
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
                _emailField(context),
                SizedBox(
                  height: 15,
                ),
                _passwordField(context),
                SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                    onPressed: () async {
                      var isValid = await sl<SignUpUseCase>().call(
                        params: SignUpRequest(
                          username: _userNameController.text,
                          email: _emailController.text,
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
                          SnackBar(
                            content: Text("Invalid Credentials"),
                          ),
                        );
                      }
                    },
                    child: Text("SignUp"))
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _signInText(context),
    );
  }

  Widget _registerText() {
    return Text(
      "Sign Up",
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
        hintText: "username",
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

  Widget _emailField(BuildContext context) {
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        hintText: "email",
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

  Widget _passwordField(BuildContext context) {
    return TextField(
      controller: _passwordController,
      decoration: InputDecoration(
        hintText: "Password",
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

  Widget _signInText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Do you have an account? ",
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
                  builder: (BuildContext builder) => Signin(),
                ),
              );
            },
            child: Text("Sign In"),
          ),
        ],
      ),
    );
  }
}
