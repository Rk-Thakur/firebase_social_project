import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_project/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final userProvider = StreamProvider((ref) => UserProvider().getUsers());


class UserProvider {


  CollectionReference dbUser = FirebaseFirestore.instance.collection('users');

  Stream<List<UserC>> getUsers(){
     final data = dbUser.snapshots().map((event) => _getFromSnap(event));
     return data;
  }

  List<UserC> _getFromSnap(QuerySnapshot querySnapshot){
     return querySnapshot.docs.map((e) => UserC.fromJson(e.data() as Map<String, dynamic>) ).toList();
  }

  Future<UserC>  getCurrentUser(String uid) async{
    final response = await dbUser.where('userId',isEqualTo: uid);
    print(response.parameters);
    return UserC.fromJson(response as Map<String, dynamic>);
  }


}


