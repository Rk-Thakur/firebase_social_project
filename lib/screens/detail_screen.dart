import 'package:firebase_project/models/comment.dart';
import 'package:firebase_project/models/post.dart';
import 'package:firebase_project/providers/crud_provider.dart';
import 'package:firebase_project/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class DetailScreen extends StatelessWidget {
  final Post post;
  DetailScreen(this.post);
  final commentController = TextEditingController();
  final _form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: Consumer(
            builder: (context, ref, child) {
              final currentUser = ref.watch(currentUserProvider);
              return Form(
                key: _form,
                child: ListView(
                  children: [
                    Image.network(post.imageUrl),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(post.title, style: TextStyle(
                              fontSize: 22, color: Colors.blueGrey),),
                          SizedBox(height: 15,),
                          Text(post.detail, style: TextStyle(
                              fontSize: 17, color: Colors.orange),),
                          TextFormField(
                            controller: commentController,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'please put some comment';
                              }
                              if (val.length > 90) {
                                return 'maximum word is 90';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                hintText: 'add comment'
                            ),
                          ),
                          SizedBox(height: 10,),
                          Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                  onPressed: () async {
                                    _form.currentState!.save();
                                    if (_form.currentState!.validate()) {
                                      final newComment = Comment(
                                          imageUrl: currentUser.userImage,
                                          username: currentUser.username,
                                          comment: commentController.text.trim()
                                      );
                                       final comment = [...post.comments, newComment];
                               final response =    await   ref.read(crudProvider).addComment(
                                          postId: post.id,
                                          comments: comment
                                      );
                               if(response == 'success'){
                                 Navigator.of(context).pop();
                               }

                                    }
                                  }, child: Text('add comment')))
                        ],
                      ),
                    ),

                  ],
                ),
              );
            }
          ),
        )
    );
  }
}
