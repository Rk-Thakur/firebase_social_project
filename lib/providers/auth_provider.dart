import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';



final authProvider = StreamProvider((ref) => FirebaseAuth.instance.authStateChanges());

final logSignProvider = Provider((ref) => LoginSignUpProvider());


class LoginSignUpProvider{



  CollectionReference dbUser = FirebaseFirestore.instance.collection('users');

  Future<String> signUp({required String email, required String password, required String userName, required XFile image}) async{

    try{
      final imageFile = File(image.path);
      final imageId = DateTime.now().toString();
      final ref = FirebaseStorage.instance.ref().child('userImage/$imageId');
       await ref.putFile(imageFile);
       final url = await ref.getDownloadURL();
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email, password: password
      );
      dbUser.add({
        'username': userName,
        'email': email,
        'userImage': url,
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