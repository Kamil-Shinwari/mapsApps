import 'package:firebase_auth/firebase_auth.dart';

class authclass{

  
   static Future signUp({String? email, String? password}) async {
    FirebaseAuth _auth= FirebaseAuth.instance;
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

static  Future signIn({String? email, String? password}) async {
  FirebaseAuth _auth= FirebaseAuth.instance;
    try {
      await _auth.signInWithEmailAndPassword(email: email!, password: password!);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}