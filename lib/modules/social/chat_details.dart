import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/social_cubit/cubit_shop.dart';
import '../../cubit/social_cubit/states_shop.dart';
import '../../model/message_model.dart';
import '../../model/social_model.dart';

var messageController = TextEditingController();
var scrollController = ScrollController();

class ChatDetailsScreen extends StatelessWidget {
  final SocialModel user;

  const ChatDetailsScreen({required this.user, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      SocialCubit.get(context).getMessage(receiverId: user.uId!);
      return BlocConsumer<SocialCubit, SocialState>(
        listener: (context, state) {
          if (state is SuccessSendMessage) {
            messageController.clear();
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              titleSpacing: 0,
              title: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage('${user.image}'),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text('${user.name}'),
                ],
              ),
            ),
            body: SocialCubit.get(context).messages.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                              reverse: true,
                              controller: scrollController,
                              itemBuilder: (context, index) {
                                if (SocialCubit.get(context).userData!.uId ==
                                    SocialCubit.get(context)
                                        .messages[index]
                                        .senderId) {
                                  return buildMyMessage(
                                      SocialCubit.get(context).messages[index],index);
                                }

                                return buildMessage(
                                    SocialCubit.get(context).messages[index],index);
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                    height: 10,
                                  ),
                              itemCount:
                                  SocialCubit.get(context).messages.length),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey.shade300, width: 1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Row(
                            children: [
                              Expanded(
                                //message form field
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: TextFormField(
                                    controller: messageController,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Message'),
                                  ),
                                ),
                              ),
                              Container(
                                height: 63,
                                color: Colors.blue,
                                child: MaterialButton(
                                  minWidth: 1.0,
                                  onPressed: () {
                                    scrollController.animateTo(
                                        scrollController
                                            .position.minScrollExtent,
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.easeOut);
                                    SocialCubit.get(context).sendMessage(
                                      text: messageController.text,
                                      receiverId: user.uId!,
                                    );
                                  },
                                  child: const Icon(
                                    Icons.send_outlined,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
          );
        },
      );
    });
  }

//MessageModel message
  Widget buildMessage(MessageModel model, index) => Padding(
        padding: EdgeInsets.only(
          bottom: (index == 0) ? 15 : 0,
        ),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadiusDirectional.only(
                  topEnd: Radius.circular(8),
                  bottomStart: Radius.circular(8),
                  bottomEnd: Radius.circular(8),
                )),
            // child: Text('${message.text}'),
            child: Text(model.text!),
          ),
        ),
      );

  Widget buildMyMessage(MessageModel model, index) => Padding(
        padding: EdgeInsets.only(
          bottom: (index == 0) ? 15 : 0,
        ),
        child: Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
              borderRadius: const BorderRadiusDirectional.only(
                topStart: Radius.circular(8),
                bottomStart: Radius.circular(8),
                bottomEnd: Radius.circular(8),
              ),
            ),
            // child: Text('${message.text}'),
            child: Text(model.text!),
          ),
        ),
      );
}
