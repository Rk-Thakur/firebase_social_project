import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final userProvider = StreamProvider((ref) => UserProvider().getUsers());
final loginUserProvider = FutureProvider.autoDispose((ref) => UserProvider().getLoginUserData());


class UserProvider {


  final auth = FirebaseAuth.instance.currentUser!.uid;

  CollectionReference dbUser = FirebaseFirestore.instance.collection('users');

  Stream<List<UserC>> getUsers(){
     final data = dbUser.snapshots().map((event) => _getFromSnap(event));
     return data;
  }

  List<UserC> _getFromSnap(QuerySnapshot querySnapshot){
     return querySnapshot.docs.map((e) => UserC.fromJson(e.data() as Map<String, dynamic>) ).toList();
  }

Future<UserC> getLoginUserData() async {
    final response = await dbUser.where('userId', isEqualTo: auth).get();
  return   UserC.fromJson(response.docs[0].data() as Map<String, dynamic> );
}

}


