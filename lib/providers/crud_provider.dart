import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_project/models/comment.dart';
import 'package:firebase_project/models/post.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';


final crudProvider = Provider((ref) => CrudProvider());

class CrudProvider{

  CollectionReference dbPost = FirebaseFirestore.instance.collection('posts');

  Future<String> updatePost({required String title, required String detail,  XFile? image,
    required String postId, required String imageId}) async{
    try{
      if(image == null){
     await   dbPost.doc(postId).update({
          'title': title,
          'detail': detail,
        });
      }else{
        final ref = FirebaseStorage.instance.ref().child('postImage/$imageId');
        await ref.delete();
        final imageFile = File(image.path);
        final imageId1 = DateTime.now().toString();
        final ref1 = FirebaseStorage.instance.ref().child('postImage/$imageId1');
        await ref1.putFile(imageFile);
        final url = await ref1.getDownloadURL();
    await    dbPost.doc(postId).update({
          'title': title,
          'detail': detail,
          'imageUrl': url,
          'imageId': imageId1
        });

      }

      return 'success';
    }on FirebaseException catch (err){
      print(err);
      return '';
    }


  }


  Future<String> removePost({required String postId, required String imageId}) async{
    try{
        final ref = FirebaseStorage.instance.ref().child('postImage/$imageId');
        await ref.delete();
        await   dbPost.doc(postId).delete();
      return 'success';
    }on FirebaseException catch (err) {
      print(err);
      return '';
    }

  }


  Future<String> addLike({required String postId, required Like like}) async{
    try{
      await   dbPost.doc(postId).update({
        'likes': like.toJson()
      });
      return 'success';
    }on FirebaseException catch (err) {
      print(err);
      return '';
    }

  }


  Future<String> addComment({required String postId, required List<Comment> comments}) async{
    try{
      await   dbPost.doc(postId).update({
        'comments': comments.map((e) => e.toJson()).toList()
      });
      return 'success';
    }on FirebaseException catch (err) {
      print(err);
      return '';
    }

  }





}