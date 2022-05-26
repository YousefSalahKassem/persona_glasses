import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:persona/Pages/HomeScreen/menu_screen.dart';
class Authentication with ChangeNotifier{
  final FirebaseAuth firebaseAuth=FirebaseAuth.instance;
  final GoogleSignIn googleSignIn=GoogleSignIn();

  late String userUid;
  String get getUserUid=>userUid;

  Future createAccount(String email,String password,String name)async{
    UserCredential userCredential=await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    userUid=FirebaseAuth.instance.currentUser!.uid;
    User? user=userCredential.user;
    user!.updateProfile(displayName: name,photoURL: 'https://firebasestorage.googleapis.com/v0/b/ieeesystem.appspot.com/o/user.png?alt=media&token=e9f59c0f-317d-466e-ace1-a64e1283ebb3'); //added this line
    notifyListeners();
  }

  Future logIntoAccount(String email,String password)async{
    UserCredential userCredential=await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    userUid=FirebaseAuth.instance.currentUser!.uid;
    notifyListeners();
  }

  Future signInWithGoogle()async{
    final GoogleSignInAccount? googleSignInAccount=await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication=await googleSignInAccount!.authentication;
    final AuthCredential authCredential=GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken
    );
    final UserCredential userCredential=await firebaseAuth.signInWithCredential(authCredential);
    final User? user=userCredential.user;
    userUid=user!.uid;
    notifyListeners();
  }

  Future signOut()async{
    return FirebaseAuth.instance.signOut();
  }



  void signInWithFacebook(BuildContext context)async{
    try{
      final LoginResult loginResult=await FacebookAuth.instance.login();
      final facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
      await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential).whenComplete(() => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const MenuScreen() )));
    }
    catch(e){
      print(e.toString());
    }

  }
}