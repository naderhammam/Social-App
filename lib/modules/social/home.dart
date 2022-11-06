import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:social_app/cubit/social_cubit/cubit_shop.dart';
import 'package:social_app/cubit/social_cubit/states_shop.dart';
import 'package:social_app/model/posts_model.dart';

import 'comment_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is LoadingGetUserData || state is LoadingGetPosts) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  SizedBox(
                    height: height * 0.25,
                    child: Card(
                      elevation: 5,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      margin: const EdgeInsets.all(10),
                      child: Image(
                          width: width,
                          fit: BoxFit.cover,
                          image: const NetworkImage(
                              'https://img.freepik.com/free-photo/shot-pleasant-looking-dark-skinned-curly-woman-holds-finger-near-mouth-smiles-broadly-looks-positively-has-partly-crossed-arms-wears-earrings-turtleneck-isolated-white_273609-27901.jpg?w=996&t=st=1660326357~exp=1660326957~hmac=7e3ddd03b0bb078bc23697672620de77d3b6554503219f440a01a93f5cb4ba08')),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text('Communicate with your friends',
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
                              fontSize: 12,
                              color: Colors.blue,
                            )),
                  ),
                ],
              ),
              SizedBox(height: height * 0.0009),
              ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => buildPostItem(
                      context, SocialCubit.get(context).posts[index], index),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemCount: SocialCubit.get(context).posts.length),
            ],
          ),
        );
      },
    );
  }

  Widget buildPostItem(context, PostModel model, index) => Card(
        elevation: 5,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  //profile photo
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(
                      model.image!,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  //name , check mark & date
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //name & check mark
                        Row(
                          children: [
                            Text(model.name!),
                            const SizedBox(
                              width: 5,
                            ),
                            const Icon(
                              Icons.check_circle,
                              color: Colors.blue,
                              size: 16,
                            )
                          ],
                        ),
                        //date and time
                        Text(
                          model.time!,
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              ?.copyWith(height: 1.6),
                        ),
                      ],
                    ),
                  ),
                  //three dots
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.more_horiz,
                      size: 18,
                    ),
                  ),
                ],
              ),
              //separator
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Container(
                  height: 1,
                  color: Colors.grey[300],
                ),
              ),
              Text(
                model.text!,
                style: const TextStyle(
                  height: 1.3,
                  fontSize: 16,
                ),
              ),
              //hashtag text
              // Padding(
              //   padding: const EdgeInsets.only(
              //     bottom: 8,
              //   ),
              //   child: SizedBox(
              //     width: double.infinity,
              //     child: Wrap(
              //       children: [
              //         SizedBox(
              //           height: 25,
              //           child: MaterialButton(
              //             minWidth: 1.0,
              //             padding: EdgeInsets.zero,
              //             onPressed: () {},
              //             child: const Text(
              //               '#hashtag',
              //               style: TextStyle(
              //                 color: Colors.blue,
              //               ),
              //             ),
              //           ),
              //         ),
              //         SizedBox(
              //           height: 25,
              //           child: MaterialButton(
              //             minWidth: 1.0,
              //             padding: EdgeInsets.zero,
              //             onPressed: () {},
              //             child: const Text(
              //               '#hashtag2',
              //               style: TextStyle(
              //                 color: Colors.blue,
              //               ),
              //             ),
              //           ),
              //         ),
              //         SizedBox(
              //           height: 25,
              //           child: MaterialButton(
              //             minWidth: 1.0,
              //             padding: EdgeInsets.zero,
              //             onPressed: () {},
              //             child: const Text(
              //               '#averylooooooooooooooooonghashtag',
              //               style: TextStyle(
              //                 color: Colors.blue,
              //               ),
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              //photo of post
              if (model.imagePost != '')
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    height: 140,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                          image: NetworkImage(model.imagePost!),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
              //likes and comments
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.favorite_border,
                                size: 16,
                                color: Colors.red,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('posts')
                                    .doc(
                                        SocialCubit.get(context).postsId[index])
                                    .collection('likes')
                                    .snapshots(),
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                      '${snapshot.data!.docs.length}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          ?.copyWith(height: 1.6),
                                    );
                                  } else {
                                    return const Text('0');
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        onTap: () {},
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('posts')
                                    .doc(
                                        SocialCubit.get(context).postsId[index])
                                    .collection('comments')
                                    .snapshots(),
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                      '${snapshot.data!.docs.length}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          ?.copyWith(height: 1.6),
                                    );
                                  } else {
                                    return const Text('7');
                                  }
                                },
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Icon(
                                Icons.comment_outlined,
                                size: 16,
                                color: Colors.amber,
                              ),
                            ],
                          ),
                        ),
                        onTap: () {

                          print(
                              DateFormat(
                                'MMM d, hh:mm aaa'
                              ).format(DateTime.now())
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              //separator
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  height: 1,
                  color: Colors.grey[300],
                ),
              ),
              //comment like share
              Row(
                children: [
                  //write a comment
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        SocialCubit.get(context).getIdPostsTest(
                            SocialCubit.get(context).postsId[index]);
                        String refresh = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CommentsScreen(
                                      indexComments: index,
                                    )));
                        if (refresh == 'refresh') {
                          SocialCubit.get(context).getPosts();
                        }
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 15,
                            backgroundImage: NetworkImage(
                                SocialCubit.get(context).userData!.image!),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            'write a comment',
                            style:
                                Theme.of(context).textTheme.caption?.copyWith(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //like button
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(SocialCubit.get(context).postsId[index])
                        .snapshots(),
                    builder:
                        (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return InkWell(
                          child: Row(
                            children: [
                              Icon(
                                Icons.favorite,
                                size: 16,
                                color: (snapshot.data!['like'] == true)
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Like',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(
                                      color: (snapshot.data!['like'] == true)
                                          ? Colors.red
                                          : Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          onTap: () {
                            SocialCubit.get(context).likePost(
                                SocialCubit.get(context).postsId[index], index);
                          },
                        );
                      } else {
                        return const Text('0');
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      );
}
