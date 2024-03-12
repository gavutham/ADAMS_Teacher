import "package:adams_teacher/models/teacher.dart";
import "package:adams_teacher/services/auth.dart";
import "package:adams_teacher/services/bluetooth.dart";
import "package:adams_teacher/services/database.dart";
import "package:adams_teacher/services/server.dart";
import "package:adams_teacher/shared/constants.dart" as constants;
import "package:adams_teacher/shared/loading.dart";
import "package:flutter/cupertino.dart";
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
  bool manual = false;
  String? year;
  String? dept;
  String? sec;
  String? time;

  static const years = ["I", "II", "III", "IV"];
  static const depts = constants.departments;
  static const sections = ["A", "B", "C"];
  static const times = ["1", "2", "3", "4", "5", "6", "7", "8"];

  DropdownMenuItem<String> toDropDownItem (value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    final teacher = Provider.of<TeacherData?>(context);

    Future handleSubmit() async {
      if (teacher != null) {
        setState(() {
          loading = true;
        });

        var _year;
        var _dept;
        var _sec;

        if (!manual) {
          (_year, _dept, _sec) = (await (DatabaseService(tid: teacher.tid)).openAttendance(teacher.classes, teacher.tid));
        } else {
          (_year, _dept, _sec) = (year, dept, sec);
          print("manual");
        }

        startSession(_year, _dept, _sec);

        turnOn();
        var nearby = await getDevices();

        await postNearbyDevices(nearby, {"year":_year, "dept":_dept, "sec":_sec});

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
            CupertinoSwitch(
              value: manual,
              onChanged: (value) {
                setState(() {
                  manual = value;
                  print(manual);
                });
              },
            ),
            AbsorbPointer(
              absorbing: !manual,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                child: Wrap(
                  spacing: 10,
                  children: [
                    DropdownButton(
                      items: years.map((e) => toDropDownItem(e)).toList(),
                      onChanged: (val) {
                        if(val != null) {
                          year = val;
                          print(val);
                        }
                      },
                      hint: Container(
                        width: 100,
                        child: Text(
                          year ?? "Year",
                          style: const TextStyle(color: Colors.grey),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                    DropdownButton(
                      value: dept,
                      items: depts.map((e) => toDropDownItem(e)).toList(),
                      onChanged: (val) {
                        if(val != null) {
                          dept = val;
                          print(val);
                        }
                      },
                      hint: Container(
                        width: 100,
                        child: Text(
                          dept ?? "Dept",
                          style: const TextStyle(color: Colors.grey),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                    DropdownButton(
                      value: sec,
                      items: sections.map((e) => toDropDownItem(e)).toList(),
                      onChanged: (val) {
                        if(val != null) {
                          sec = val;
                          print(val);
                        }
                      },
                      hint: Container(
                        width: 100,
                        child: Text(
                          sec ?? "Sec",
                          style: const TextStyle(color: Colors.grey),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                    DropdownButton(
                      value: time,
                      items: times.map((e) => toDropDownItem(e)).toList(),
                      onChanged: (val) {
                        if(val != null) {
                          time = val;
                          print(val);
                        }
                      },
                      hint: Container(
                        width: 100,
                        child: Text(
                          time ?? "Time",
                          style: const TextStyle(color: Colors.grey),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ) ,
    ) : const Loading();
  }
}