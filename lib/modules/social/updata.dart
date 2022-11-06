import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/social_cubit/cubit_shop.dart';
import 'package:social_app/cubit/social_cubit/states_shop.dart';
import '../../style/iCONS.dart';

var nameController = TextEditingController();
var bioController = TextEditingController();
var phoneController = TextEditingController();

class UpdateScreen extends StatelessWidget {
  const UpdateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var userData = SocialCubit.get(context).userData;
        var image = SocialCubit.get(context).profileImage;
        var cover = SocialCubit.get(context).coverImage;

        if (state is LoadingGetUserData) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        nameController.text = userData!.name!;
        bioController.text = userData.bio!;
        phoneController.text = userData.phone!;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit Profile'),
            actions: [
              TextButton(
                  onPressed: () {
                    SocialCubit.get(context).updateUserText(
                        bio: bioController.text,
                        name: nameController.text,
                        phone: phoneController.text);
                  },
                  child: const Text('Save')),
            ],
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context, 'refresh');
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 193,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Container(
                                height: 150,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  image: DecorationImage(
                                      image: cover == null
                                          ? NetworkImage(
                                              '${userData.cover}',
                                            )
                                          : FileImage(cover) as ImageProvider,
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
                                          SocialCubit.get(context)
                                              .getCoverData();
                                        },
                                        icon: const Icon(
                                          IconBroken.Camera,
                                        )),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 59,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              child: CircleAvatar(
                                radius: 56,
                                backgroundImage: image == null
                                    ? NetworkImage(
                                        '${userData.image}',
                                      )
                                    : FileImage(image) as ImageProvider,
                              ),
                            ),
                            CircleAvatar(
                              radius: 16,
                              child: FittedBox(
                                child: IconButton(
                                    onPressed: () {
                                      SocialCubit.get(context).getProfileData();
                                    },
                                    icon: const Icon(
                                      IconBroken.Camera,
                                    )),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      if (image != null)
                        Expanded(
                        child: Column(
                          children: [
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                    onPressed: () {
                                      SocialCubit.get(context).uploadProfile(
                                          bio: bioController.text,
                                          name: nameController.text,
                                          phone: phoneController.text);
                                    },
                                    child: const Text('Upload Profile')),
                              ),
                            if (state is LoadingUploadProfileUrl)
                              const SizedBox(
                                height: 3,
                              ),
                            if (state is LoadingUploadProfileUrl)
                              const LinearProgressIndicator()
                          ],
                        ),
                      ),
                      if (image != null && cover != null)
                        const SizedBox(
                          width: 12,
                        ),
                      if (cover != null)
                        Expanded(
                        child: Column(
                          children: [
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                    onPressed: () {
                                      SocialCubit.get(context).uploadCover(
                                          bio: bioController.text,
                                          name: nameController.text,
                                          phone: phoneController.text);
                                    },
                                    child: const Text('Upload Profile')),
                              ),
                            if (state is LoadingUploadCoverUrl)
                              const SizedBox(
                                height: 3,
                              ),
                            if (state is LoadingUploadCoverUrl)
                              const LinearProgressIndicator()
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (image != null || cover != null)
                    const SizedBox(
                      height: 25,
                    ),

                  TextFormField(
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.person,
                      ),
                      label: Text('Name'),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'name cannot be empty';
                      }
                      return null;
                    },
                    controller: nameController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //bio
                  TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.info_outline,
                      ),
                      label: Text('Bio'),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'bio cannot be empty';
                      }
                      return null;
                    },
                    controller: bioController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //phone
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.phone_android_outlined,
                      ),
                      label: Text('Phone'),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'phone cannot be empty';
                      }
                      return null;
                    },
                    controller: phoneController,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
