import 'package:adams_teacher/models/teacher.dart';
import 'package:adams_teacher/screens/wrapper.dart';
import 'package:adams_teacher/services/auth.dart';
import 'package:adams_teacher/services/database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TeacherUser?>(
      stream: AuthService().user,
      builder: (context, snapshot) {
        final user = snapshot.hasData ? snapshot.data : null;

        return StreamBuilder<TeacherData?>(
          initialData: null,
          stream: DatabaseService(tid: user?.tid).teacherData,

          builder: (context, snapshot) {
            return MultiProvider(
              providers: [
                StreamProvider<TeacherUser?>.value(
                  value: AuthService().user,
                  initialData: null,
                ),
                StreamProvider<TeacherData?>.value(
                  value: DatabaseService(tid: user?.tid).teacherData,
                  initialData: null,
                ),
              ],
              child: const MaterialApp(
                home: Wrapper(),
                debugShowCheckedModeBanner: false,
              ),
            );
          },
        );
      },
    );
  }
}

