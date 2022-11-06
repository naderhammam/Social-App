import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/social_cubit/cubit_shop.dart';
import '../../cubit/social_cubit/states_shop.dart';

class NewPostScreen extends StatelessWidget {
  NewPostScreen({Key? key}) : super(key: key);
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {
        if (state is SuccessCreatePosts) {
          Navigator.pop(context, 'refresh');
        }
      },
      builder: (context, state) {

        if (state is LoadingGetUserData || state is LoadingGetPosts) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('New post'),
            actions: [
              MaterialButton(
                onPressed: () {
                  if (SocialCubit.get(context).postImage == null) {
                    SocialCubit.get(context)
                        .createPosts(text: textController.text);
                  } else {
                    SocialCubit.get(context)
                        .uploadPost(text: textController.text);
                  }
                },
                textColor: Colors.blue,
                child: const Text('POST'),
              ),
            ],
            leading: MaterialButton(
              onPressed: () {
                Navigator.pop(context, 'refresh');
              },
              textColor: Colors.blue,
              child: const Padding(
                padding: EdgeInsets.only(
                  left: 8.0,
                ),
                child: Icon(Icons.arrow_back),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                if (state is LoadingUploadPosts || state is LoadingCreatePosts)
                  const LinearProgressIndicator(),
                if (state is LoadingUploadPosts || state is LoadingCreatePosts)
                  const SizedBox(height: 20),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundImage: NetworkImage(
                        '${SocialCubit.get(context).userData!.image}',
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Text(
                        SocialCubit.get(context).userData!.name!,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TextFormField(
                    controller: textController,
                    decoration: const InputDecoration(
                      hintText: "what's in your mind?",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (SocialCubit.get(context).postImage != null)
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        height: 170,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                              image: FileImage(
                                  SocialCubit.get(context).postImage!),
                              fit: BoxFit.cover),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 16,
                          child: FittedBox(
                            child: IconButton(
                                onPressed: () {
                                  SocialCubit.get(context).removePostImage();
                                },
                                icon: const Icon(
                                  Icons.close,
                                )),
                          ),
                        ),
                      )
                    ],
                  ),
                if (SocialCubit.get(context).postImage != null)
                  const SizedBox(
                    height: 20,
                  ),
                Row(
                  children: [
                    //add photo
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          SocialCubit.get(context).getPostImage();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text('add photo'),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.tag),
                            SizedBox(
                              width: 5,
                            ),
                            Text('tags'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
