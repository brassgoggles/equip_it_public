import 'package:flutter/material.dart';

import '../constants.dart';
import '../widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              const SizedBox(height: 50),
              FormContainerWidget(
                horizontalMargin: Constants.formMarginHorizontal,
                bodyWidget: Column(
                  children: [
                    const Text(
                      "Login",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                    const SizedBox(height: 20),
                    EntryFieldWidget(controller: _emailCtrl, name: "Email..."),
                    const SizedBox(height: 20),
                    EntryFieldWidget(
                        controller: _passwordCtrl, name: "Password..."),
                    const SizedBox(height: 20),
                    ButtonWidget(onPressed: () {}, text: "Sign In"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
