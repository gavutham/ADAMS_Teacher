import "package:adams_teacher/models/teacher.dart";
import "package:adams_teacher/screens/authentication/authWrapper.dart";
import 'package:adams_teacher/screens/home/home.dart';
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TeacherUser?>(context);

    return user != null ? Home() : const AuthWrapper();
  }
}
