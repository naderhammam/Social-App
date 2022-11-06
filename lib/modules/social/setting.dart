import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:social_app/cubit/social_cubit/cubit_shop.dart';
import 'package:social_app/cubit/social_cubit/states_shop.dart';
import 'package:social_app/modules/social/updata.dart';

import '../../style/iCONS.dart';

class ScreenScreen extends StatelessWidget {
  const ScreenScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {
        if (state is NavigatorPop) {
          SocialCubit.get(context).getUserData();
        }
      },
      builder: (context, state) {
        if (state is LoadingGetUserData) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        var cubit = SocialCubit.get(context).userData;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 193,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                              image: NetworkImage(
                                '${cubit!.cover}',
                              ),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 59,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      child: CircleAvatar(
                        radius: 56,
                        backgroundImage: NetworkImage(
                          '${cubit.image}',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text('${cubit.name}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(height: 1.3)),
              Text(
                '${cubit.bio}',
                style: Theme.of(context).textTheme.caption,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text('120',
                            style: Theme.of(context).textTheme.subtitle1),
                        Text(
                          'posts',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text('265',
                            style: Theme.of(context).textTheme.subtitle1),
                        Text(
                          'photos',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text('10k',
                            style: Theme.of(context).textTheme.subtitle1),
                        Text(
                          'followers',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text('64',
                            style: Theme.of(context).textTheme.subtitle1),
                        Text(
                          'following',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  children: [
                    Expanded(
                        child: OutlinedButton(
                      onPressed: () {
                        print(DateFormat('h:mm a').format(DateTime.now()).toString()) ;
                      },
                      child: const Text('Add Photos'),
                    )),
                    const SizedBox(
                      width: 10,
                    ),
                    OutlinedButton(
                      onPressed: () async {
                        String refresh = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const UpdateScreen()));
                        if (refresh == 'refresh') {
                          SocialCubit.get(context).getUserData();
                        }
                      },
                      child: const Icon(IconBroken.Edit),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
