import 'package:amazonclone/common/widgets/custom_button.dart';
import 'package:amazonclone/common/widgets/custom_texfield.dart';
import 'package:amazonclone/constants/global_variables.dart';
import 'package:amazonclone/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';

enum Auth {
  signin,
  singUp,
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Auth _auth = Auth.singUp;
  final _signUpFormKey = GlobalKey<FormState>();
  final _signInFormKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  final AuthService authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void signUpUser() {
    authService.signUpUser(
        context: context,
        email: _emailController.text,
        password: _passwordController.text,
        name: _nameController.text);
  }

  void signIpUser() {
    authService.signIngUser(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.greyBackgroundCOlor,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
            ),
            ListTile(
              tileColor:
                  _auth == Auth.singUp ? GlobalVariables.backgroundColor : null,
              title: const Text(
                "Create Account",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: Radio(
                value: Auth.singUp,
                groupValue: _auth,
                onChanged: (Auth? val) {
                  setState(() {
                    _auth = val!;
                  });
                },
                activeColor: GlobalVariables.secondaryColor,
              ),
            ),
            _auth == Auth.singUp
                ? Container(
                    padding: const EdgeInsets.all(
                      8,
                    ),
                    color: GlobalVariables.backgroundColor,
                    child: Form(
                      key: _signUpFormKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            hintText: "Name",
                            controller: _nameController,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextField(
                            hintText: "Email",
                            controller: _emailController,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextField(
                            hintText: "Password",
                            controller: _passwordController,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomButton(
                            text: "Sign Up",
                            onTap: () {
                              if (_signUpFormKey.currentState!.validate()) {
                                signUpUser();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox(),
            ListTile(
              tileColor:
                  _auth == Auth.signin ? GlobalVariables.backgroundColor : null,
              title: const Text(
                "Sign-In",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: Radio(
                value: Auth.signin,
                groupValue: _auth,
                onChanged: (Auth? val) {
                  setState(() {
                    _auth = val!;
                  });
                },
                activeColor: GlobalVariables.secondaryColor,
              ),
            ),
            _auth == Auth.signin
                ? Container(
                    padding: const EdgeInsets.all(
                      8,
                    ),
                    color: GlobalVariables.backgroundColor,
                    child: Form(
                      key: _signInFormKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            hintText: "Email",
                            controller: _emailController,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextField(
                            hintText: "Password",
                            controller: _passwordController,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomButton(
                            text: "Sign-In",
                            onTap: () {
                              if (_signInFormKey.currentState!.validate()) {
                                signIpUser();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      )),
    );
  }
}
