import 'package:adams_teacher/models/teacher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  String? tid;

  DatabaseService({required this.tid});

  final CollectionReference teacherCollection = FirebaseFirestore.instance.collection("teachers");

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
}