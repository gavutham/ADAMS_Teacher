import 'package:adams_teacher/services/auth.dart';
import 'package:adams_teacher/shared/loading.dart';
import 'package:flutter/material.dart';
import "package:adams_teacher/shared/constants.dart" as constants;
import 'package:multi_select_flutter/multi_select_flutter.dart';

class SignUp extends StatefulWidget {
  final void Function() toggleView;
  const SignUp({super.key, required this.toggleView});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final _formKey = GlobalKey<FormState>();
  final _auth = AuthService();

  //form fields
  String name = "";
  String email = "";
  String password = "";
  List classes = [];

  bool loading = false;
  String error = "";

  @override
  Widget build(BuildContext context) {
    return loading ? const Loading() : Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
        actions: [
          ElevatedButton(
            onPressed: widget.toggleView,
            child: const Text("Sign In"),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 75),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(hintText: "Name"),
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty){
                      return "Please enter a valid name";
                    }
                    else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 20,),
                TextFormField(
                  decoration: const InputDecoration(hintText: "Email"),
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty){
                      return "Please enter a valid email";
                    }
                    else {
                      return null;
                    }
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
                  validator: (value) {
                    if (value!.isEmpty){
                      return "Please enter a valid password";
                    }
                    else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 20,),
                MultiSelectDialogField(
                  items: constants.departments.map((e) => MultiSelectItem(e, e)).toList(),
                  initialValue: classes,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please select at least one department";
                    } else {
                      return null;
                    }
                  },
                  title: const Text("Select the Undertaking Departments"),
                  onConfirm: (values) {
                    setState(() {
                      classes = values;
                    });
                  },
                ),
                const SizedBox(height: 20,),
                ElevatedButton(
                  child: const Text("Sign Up"),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        loading = true;
                        error = "";
                      });
                      dynamic user = await _auth.teacherSignUp(name, email, password, classes);
                      if (user == null ){
                        setState(() {
                          loading = false;
                          error = "Something went wrong please try again";
                        });
                      }
                    }
                  },
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
          )
        ),

      )
    );
  }
}
