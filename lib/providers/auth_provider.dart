import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



final authProvider = StreamProvider((ref) => FirebaseAuth.instance.authStateChanges());

final logSignProvider = Provider((ref) => LoginSignUpProvider());


class LoginSignUpProvider{



  CollectionReference dbUser = FirebaseFirestore.instance.collection('users');

  Future<String> signUp({required String email, required String password, required String userName}) async{

    try{
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email, password: password
      );
      dbUser.add({
        'username': userName,
        'email': email,
      });

      return 'success';
    }on FirebaseException catch (err){
      print(err);
      return '';
    }


  }


  Future<String> Login({required String email, required String password}) async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: password);
      return 'success';
    }on FirebaseException catch (err){
      print(err);
      return '';
    }
  }


  Future<String> LogOut() async{
    try{
      await FirebaseAuth.instance.signOut();
      return 'success';
    }on FirebaseException catch (err){
      print(err);
      return '';
    }
  }



}