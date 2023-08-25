import 'package:adams_teacher/models/teacher.dart';
import 'package:adams_teacher/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  TeacherUser? _teacherUserFromFirebase(User? user) {
    return user != null ? TeacherUser(tid: user.uid) : null;
  }

  Stream<TeacherUser?> get user {
    return _auth.authStateChanges().map(_teacherUserFromFirebase);
  }

  Future teacherSignIn(String email, String password) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _teacherUserFromFirebase(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  Future teacherSignUp(String name, String email, String password, List classes) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      await DatabaseService(tid: user!.uid).setTeacherDetail(
          TeacherData(
            email: email,
            name: name,
            classes: classes,
            tid: user.uid,
          )
      );
      return _teacherUserFromFirebase(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }


  Future signOut() async {
    try{
      return await _auth.signOut();
    }catch (err){
      print(err.toString());
      return null;
    }
  }

}