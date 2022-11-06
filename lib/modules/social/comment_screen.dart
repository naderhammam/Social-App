import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/social_cubit/cubit_shop.dart';
import 'package:social_app/cubit/social_cubit/states_shop.dart';
import 'package:social_app/model/posts_model.dart';

var commentController = TextEditingController();
var formKey = GlobalKey<FormState>();
String yourComment = '';

class CommentsScreen extends StatefulWidget {
  final int indexComments;

  const CommentsScreen({required this.indexComments, Key? key})
      : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {
        if (state is SuccessCommentPosts) {
          commentController.clear();
          yourComment = '';
        }
      },
      builder: (context, state) {
        if (state is LoadingGetUserData || state is LoadingGetPosts) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    commentController.clear();
                    yourComment = '';
                  },
                ),
              ),
              title: const Text(
                'Comments',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              centerTitle: true,
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.only(
                left: 15,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  commentController.clear();
                  yourComment = '';
                },
              ),
            ),
            title: const Text(
              'Comments',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            centerTitle: true,
          ),
          body: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 8,
                ),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(SocialCubit.get(context).postIdTest)
                        .collection('comments')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      List<CommentModel> comments = [];

                      if (snapshot.hasData) {
                        for (var element in snapshot.data!.docs) {
                          comments.add(CommentModel.fromJson(
                              element.data() as Map<String, dynamic>));
                        }
                        return Expanded(
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return buildCommentItem(
                                comments[index],
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 8,
                            ),
                            itemCount: snapshot.data!.docs.length,
                          ),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
                Form(
                  key: formKey,
                  child: Container(
                    color: Colors.white,
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: commentController,
                              cursorColor: Colors.black,
                              onFieldSubmitted: (value) {
                                if (value.isNotEmpty) {
                                  SocialCubit.get(context).commentPost(
                                      text: yourComment,
                                      postId:
                                          SocialCubit.get(context).postIdTest);
                                }
                              },
                              onChanged: (value) {
                                setState(() {
                                  yourComment = value;
                                });
                              },
                              decoration: const InputDecoration(
                                hintText: 'Write a comment',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          SocialCubit.get(context).isComment
                              ? const Center(
                                  child: CupertinoActivityIndicator(
                                    color: Colors.black,
                                    radius: 12,
                                  ),
                                )
                              : IconButton(
                                  icon: const Icon(Icons.send),
                                  onPressed: () {
                                    if (yourComment.isNotEmpty) {
                                      SocialCubit.get(context).commentPost(
                                          text: yourComment,
                                          postId: SocialCubit.get(context)
                                              .postIdTest);
                                    }
                                  }),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildCommentItem(data) {
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              ClipOval(
                child: Image.network(
                  data.image,
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.name,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.6,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1A1F36),
                        )),
                    Row(
                      children: [
                        Text(data.text,
                            style: const TextStyle(
                              fontSize: 11,
                              height: 1.6,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFA5ACB8),
                            )),
                        Spacer(),
                        Text(data.time,
                            style: const TextStyle(
                              fontSize: 11,
                              height: 1.6,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFA5ACB8),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
