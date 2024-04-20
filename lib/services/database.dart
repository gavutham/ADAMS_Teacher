import 'package:adams_teacher/models/teacher.dart';
import 'package:adams_teacher/utils/datetime.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  String? tid;

  DatabaseService({required this.tid});

  final CollectionReference teacherCollection = FirebaseFirestore.instance.collection("teachers");
  final CollectionReference timetableCollection = FirebaseFirestore.instance.collection("timetable");

  TeacherData _teacherDataFromFirebase(Map data) {
    return TeacherData(
      name: data["name"] ?? "",
      email: data["email"] ?? "",
      tid: data["tid"] ?? "",
      classes: data["classes"] ?? [],
    );
  }


  Stream<TeacherData?> get teacherData {
    return teacherCollection.doc(tid).snapshots().map((snap) => _teacherDataFromFirebase(snap.data() as Map));
  }


  Future setTeacherDetail(TeacherData teacher) async {
    final teacherRef = teacherCollection.doc(tid);

    final teacherData = {
      "name": teacher.name,
      "email": teacher.email,
      "classes": teacher.classes,
      "tid": teacher.tid,
    };

    return await teacherRef.set(teacherData);
  }

  Future openAttendance(List classes, String tid) async {

    final currentInterval = getCurrentInterval();
    if(currentInterval == "") return null;
    final currentDay = getFormattedDay();

    try {
      for (var element in classes) {
        final [year, dept, sec] = element.split("-");
        print("$year, $dept, $sec, $currentDay, $currentInterval");
        final snapshot = await timetableCollection
            .doc(year)
            .collection(dept)
            .doc(sec)
            .collection(currentDay)
            .doc(currentInterval)
            .get();

        if (snapshot.data() == null) {
          continue;
        }

        final data = snapshot.data() as Map<String, dynamic>;

        if (data["tid"] == tid) {
          return (year, dept, sec);
        }
      }
      return null;
    }catch (err) {
      print("error");
      print(err);
      return null;
    }
  }
}