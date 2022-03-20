import 'package:firebase_project/models/comment.dart';
import 'package:firebase_project/models/post.dart';
import 'package:firebase_project/models/user.dart';
import 'package:firebase_project/providers/crud_provider.dart';
import 'package:firebase_project/providers/post_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class DetailScreen extends StatelessWidget {
  final Post post;
  final UserC currentUser;
  DetailScreen(this.post, this.currentUser);
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
              final postsStream = ref.watch(postStream);
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
                               commentController.clear();
                               FocusScope.of(context).unfocus();
                               if(response == 'success'){
                               //  Navigator.of(context).pop();
                               }

                                    }
                                  }, child: Text('add comment'))),

                         postsStream.when(
                             data: (data){
                               final dat =data.firstWhere((element) => element.id == post.id);
                               return Container(
                                 height: 400,
                                 child: ListView.builder(
                                     itemCount: dat.comments.length,
                                     itemBuilder: (context, index){
                                       return Padding(
                                         padding: const EdgeInsets.only(bottom: 5),
                                         child: Container(
                                           height:dat.comments[index].comment.length > 50 ? 160 : 120,
                                           child: Padding(
                                             padding: const EdgeInsets.all(10.0),
                                             child: Card(
                                               child: Row(
                                                 mainAxisAlignment: MainAxisAlignment.start,
                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                 children: [
                                                   Image.network(dat.comments[index].imageUrl,
                                                     width: 150,
                                                     height: 110,
                                                     fit: BoxFit.cover,
                                                     ),
                                                   SizedBox(width: 15,),
                                                   Expanded(
                                                     child: Column(
                                                       crossAxisAlignment: CrossAxisAlignment.start,
                                                       children: [
                                                         Text(dat.comments[index].username),
                                                         SizedBox(height: 10,),
                                                         Container(
                                                             height: dat.comments[index].comment.length > 50 ? 90 : 50,
                                                             child: SingleChildScrollView(child: Text(dat.comments[index].comment))),
                                                         SizedBox(height: 10,)
                                                       ],
                                                     ),
                                                   ),

                                                 ],
                                               ),
                                             ),
                                           ),
                                         ),
                                       );
                                     }),
                               );
                             },
                             error: (err, stack) => Text('$err'),
                             loading: () => Center(child: CircularProgressIndicator())
                         ),
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
