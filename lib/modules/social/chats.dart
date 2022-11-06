import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/social_cubit/cubit_shop.dart';
import '../../cubit/social_cubit/states_shop.dart';
import 'chat_details.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {},
      builder: (context, state) {
        return (SocialCubit.get(context).users.isEmpty)
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => buildChatItem(
                    context, SocialCubit.get(context).users[index]),
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                itemCount: SocialCubit.get(context).users.length,
              );
      },
    );
  }

  Widget buildChatItem(context, model) => InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatDetailsScreen(user: model)));
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              //profile photo
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(
                  '${model.image}',
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              //name , check mark & date
              Text('${model.name}'), //three dots
            ],
          ),
        ),
      );
}
