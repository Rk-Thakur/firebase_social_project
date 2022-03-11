import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';




class DrawerWidget extends StatelessWidget {
final auth = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final userData = ref.watch(loginUserProvider);
      return Drawer(
        child: userData.when(data: (data){
                 return ListView(
                   children: [
                     DrawerHeader(
                       decoration: BoxDecoration(
                         image: DecorationImage(
                           fit: BoxFit.cover,
                           image: NetworkImage(data.userImage),
                         )
                       ),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text(data.username, style: TextStyle(color: Colors.white),),
                             SizedBox(height: 90,),
                             Text(data.email, style: TextStyle(color: Colors.white),),
                           ],
                         )
                     ),
                   ],
                 );
              }, error: (err, stack) => Text('$err'), loading: () => Container(
                child: Center(
                  child: CircularProgressIndicator(
          color: Colors.purple,
        ),
                ),
              ))


      );
      },
    );
  }
}
