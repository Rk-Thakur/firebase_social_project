import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final userProvider = StreamProvider.autoDispose((ref) => UserProvider().getUsers());
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

final currentUserProvider = StateNotifierProvider.family.autoDispose<CurrentUser, UserC, String>((ref, id) => CurrentUser(uid: id));

class CurrentUser extends StateNotifier<UserC>{
  CurrentUser({required this.uid}) : super(UserC(email: '', userImage: '', username: '', userId: '')){
    getLoginUserData();
  }
 final String uid;

  Future<void> getLoginUserData() async {
    CollectionReference dbUser = FirebaseFirestore.instance.collection('users');
    final response = await dbUser.where('userId', isEqualTo: uid).get();
     state =  UserC.fromJson(response.docs[0].data() as Map<String, dynamic> );
  }
}