import 'package:firebase_project/models/user.dart';
import 'package:firebase_project/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';




class UserPage extends StatelessWidget {
 final AsyncValue<List<UserC>> userData;
 UserPage(this.userData);
  @override
  Widget build(BuildContext context) {
    return   Consumer(
      builder: (context, ref, child) {
        return Container(
          padding: EdgeInsets.all(10),
          height: 150,
          child: userData.when(
              data: (data) {
                return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(right: 15),
                        child: Column(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                  data[index].userImage
                              ),
                              radius: 40,
                            ),
                            SizedBox(height: 10,),
                            Text(data[index].username)
                          ],
                        ),
                      );
                    }
                );
              },
              error: (err, stack) => Text('$err'),
              loading: () => Container()
          ),
        );
      }
    );
  }
}
