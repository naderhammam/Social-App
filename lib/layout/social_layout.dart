import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/social_cubit/cubit_shop.dart';
import 'package:social_app/cubit/social_cubit/states_shop.dart';
import 'package:social_app/shared/component.dart';

import '../modules/social/posts.dart';
import '../style/iCONS.dart';

class SocialLayout extends StatelessWidget {
  const SocialLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) async {
        if (state is PostState) {
          String refresh = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => NewPostScreen()));
          if (refresh == 'refresh') {
            SocialCubit.get(context).getPosts();
            SocialCubit.get(context).getUserData();
          }
        }
        if (state is SuccessLogoutData) {
          uId = '';
        }
      },
      builder: (context, state) {
        var cubit = SocialCubit.get(context);

        return RefreshIndicator(
          onRefresh: () async {
            Future.delayed(const Duration(seconds: 1));
            cubit.getUserData();
            cubit.getPosts();
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Social'),
            ),
            body: cubit.screens[cubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              // type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(IconBroken.Home), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(IconBroken.Chat), label: 'CHATS'),
                BottomNavigationBarItem(
                    icon: Icon(IconBroken.Upload), label: 'POSTS'),
                BottomNavigationBarItem(
                    icon: Icon(IconBroken.User), label: 'USERS'),
                BottomNavigationBarItem(
                    icon: Icon(IconBroken.Setting), label: 'SETTING'),
              ],

              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.ChangeIndex(index);
              },
            ),
          ),
        );
      },
    );
  }
}
