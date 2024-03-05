import "package:adams_teacher/models/teacher.dart";
import "package:adams_teacher/services/auth.dart";
import "package:adams_teacher/services/bluetooth.dart";
import "package:adams_teacher/services/database.dart";
import "package:adams_teacher/services/server.dart";
import "package:adams_teacher/shared/loading.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _auth = AuthService();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final teacher = Provider.of<TeacherData?>(context);

    Future handleSubmit() async {
      if (teacher != null) {
        setState(() {
          loading = true;
        });


        var class_ = await DatabaseService(tid: teacher.tid).openAttendance(teacher.classes, teacher.tid);


        turnOn();
        var nearby = await getDevices();
        await postNearbyDevices(nearby, class_);

        setState(() {
          loading = false;
        });
      }
    }

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Welcome, ${teacher.name}", style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),),
            ElevatedButton(
              onPressed: loading ? null : handleSubmit,
              child: const Text("Open Attendance"),
            ),
          ],
        ),
      ) ,
    ) : const Loading();
  }
}