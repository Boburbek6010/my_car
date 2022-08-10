import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_car/services/db_service.dart';
import 'package:my_car/services/util_service.dart';

class AuthService{
  static final _auth = FirebaseAuth.instance;

  static Future<User?>signUpUser(BuildContext context, String email, String password, String name)async{
    try{
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      var user = credential.user;
      await _auth.currentUser?.updateDisplayName(name);
      return user;
    }catch(e){
      debugPrint(e.toString());
      Utils.fireSnackBar(e.toString(), context);
    }
    return null;
  }


  static Future<User?>signInUser(BuildContext context, String email, String password)async{
    try{
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    }catch(e){
      debugPrint(e.toString());
      Utils.fireSnackBar(e.toString(), context);
    }
    return null;
  }


  static Future<void>signOutUser(BuildContext context)async{
    await _auth.signOut();
    DBService.removeUserId().then((value) {});
  }


}