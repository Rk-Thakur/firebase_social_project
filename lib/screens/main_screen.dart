import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/models/user.dart';
import 'package:firebase_project/providers/auth_provider.dart';
import 'package:firebase_project/providers/user_provider.dart';
import 'package:firebase_project/widgets/drawer_widget.dart';
import 'package:firebase_project/widgets/user_show.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainScreen extends StatelessWidget {
  final auth = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final currentUser = FutureProvider((ref) => UserProvider().getCurrentUser(auth));
        final user = ref.watch(currentUser);
        final userData = ref.watch(userProvider);
        return Scaffold(
          drawer: DrawerWidget(),
            appBar: AppBar(
              backgroundColor: Colors.purple,
              title: Text('Main Screen'),
              actions: [
                TextButton(onPressed: (){}, child: Text('create', style: TextStyle(color: Colors.white),)),
                TextButton(onPressed: () {
              ref.read(logSignProvider).LogOut();
                },
                    child: Text(
                      'SignOut', style: TextStyle(color: Colors.white),))
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [

                UserPage(userData),

                  user.when(
                      data: (data){
                        print(data);
                        return Text(data.email);
                      },
                      error: (err, stack) => Text('$err'),
                      loading: () => CircularProgressIndicator()
                  )
                ],
              ),
            )
        );
      }
    );
  }
}
