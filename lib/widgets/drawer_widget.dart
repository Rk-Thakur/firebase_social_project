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
        final currentUser = FutureProvider((ref) => UserProvider().getCurrentUser(auth));
        final user = ref.watch(currentUser);
      return Drawer(
        child: ListView(
          children: [
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
      );
      },
    );
  }
}
