import 'package:flutter/cupertino.dart';

class TeacherUser {
  String tid;
  TeacherUser({required this.tid});
}

class TeacherData {
  String name;
  String email;
  String tid;
  List classes;

  TeacherData({
    required this.name,
    required this.email,
    required this.tid,
    required this.classes,
  });
}