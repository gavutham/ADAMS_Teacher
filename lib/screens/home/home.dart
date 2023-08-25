import "package:adams_teacher/models/teacher.dart";
import "package:adams_teacher/services/auth.dart";
import "package:adams_teacher/shared/loading.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);
  final _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final teacher = Provider.of<TeacherData?>(context);

    return teacher != null ?  Scaffold(
      appBar: AppBar(
        title: const Text("ADAMS"),
        actions: [
          ElevatedButton(
            onPressed: () {_auth.signOut();},
            child: const Text("Logout"),
          )
        ],
      ),
      body: Center(
        child: Text("Welcome to ADAMS - Teacher, ${teacher.name}", style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w900,
        ),),
      ) ,
    ) : const Loading();
  }
}