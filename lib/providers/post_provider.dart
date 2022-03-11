import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_project/models/post.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';




final postStream = StreamProvider((ref) => PostProvider().getPosts());
final postCrudProvider = Provider((ref) => PostProvider());

class PostProvider{

  CollectionReference dbPost = FirebaseFirestore.instance.collection('posts');

  Future<String> addPost({required String title, required String detail, required XFile image, required String userId}) async{
    try{
      final imageFile = File(image.path);
      final imageId = DateTime.now().toString();
      final ref = FirebaseStorage.instance.ref().child('postImage/$imageId');
      await ref.putFile(imageFile);
      final url = await ref.getDownloadURL();
      dbPost.add({
        'title': title,
        'detail': 'detail',
        'imageUrl': url,
        'userId': userId
      });

      return 'success';
    }on FirebaseException catch (err){
      print(err);
      return '';
    }


  }


  Stream<List<Post>> getPosts(){
    final data = dbPost.snapshots().map((event) => _getFromSnap(event));
    return data;
  }

  List<Post> _getFromSnap(QuerySnapshot querySnapshot){
    return querySnapshot.docs.map((e) {
      final data = e.data() as Map<String, dynamic>;
      return Post(
          detail: data['detail'],
          id: e.id,
          imageUrl: data['imageUrl'],
          title: data['title'],
          userId: data['userId']
      );
    } ).toList();
  }







}