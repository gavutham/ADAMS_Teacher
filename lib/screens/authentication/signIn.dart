import 'package:adams_teacher/services/auth.dart';
import 'package:adams_teacher/shared/loading.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final void Function() toggleView;
  const SignIn({super.key, required this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final _formKey = GlobalKey<FormState>();

  final _auth = AuthService();

  //form fields
  String email = "";
  String password = "";

  bool loading = false;
  String error = "";

  @override
  Widget build(BuildContext context) {
    return loading ? const Loading(): Scaffold(
      appBar: AppBar(
        title: const Text("Sign In"),
        actions: [
          ElevatedButton(
            onPressed: widget.toggleView,
            child: const Text("Sign Up"),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 75),
          alignment: Alignment.center,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(hintText: "Email"),
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                ),
                const SizedBox(height: 20,),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(hintText: "Password"),
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                ),
                const SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      loading = true;
                      error = "";
                    });
                    dynamic user = await _auth.teacherSignIn(email, password);
                    if (user == null) {
                      setState(() {
                        loading = false;
                        error = "Can't sign in with given Credentials";
                      });
                    }
                  },
                  child: const Text("Sign In"),
                ),
                const SizedBox(height: 20,),
                Text(
                    error,
                    style: const TextStyle(
                        color: Colors.red
                    )
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}
