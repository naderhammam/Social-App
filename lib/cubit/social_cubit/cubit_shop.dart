import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:social_app/cubit/social_cubit/states_shop.dart';
import 'package:social_app/model/message_model.dart';
import 'package:social_app/model/posts_model.dart';
import 'package:social_app/model/social_model.dart';
import 'package:social_app/modules/social/chats.dart';
import 'package:social_app/modules/social/home.dart';
import 'package:social_app/modules/social/users.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import '../../modules/login/login.dart';
import '../../modules/social/posts.dart';
import '../../modules/social/setting.dart';
import '../../network/cache_helper.dart';
import '../../shared/component.dart';

class SocialCubit extends Cubit<SocialState> {
  SocialCubit() : super(InitialState_());

  static SocialCubit get(context) => BlocProvider.of(context);

  bool isSecond = false;

  Future<void> getSomeSecond() async {
    await Future.delayed(const Duration(seconds: 4), () {});
    isSecond = true;
    emit(SuccessGetSecond());
  }

  SocialModel? userData;

  Future<void> getUserData() async {
    emit(LoadingGetUserData());
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get()
        .then((value) {
      userData = SocialModel.fromJson(value.data()!);
      print(FirebaseAuth.instance.currentUser!.email);
      // print('///////////////////////////////////////////////////////');
      // print(value.data());
      emit(SuccessGetUserData());
    }).catchError((error) {
      emit(ErrorGetUserData(error.toString()));
    });
  }

  Future<void> logout(context) async {
    await FirebaseAuth.instance.signOut().then((value) {
      CacheHelper.removeData(key: 'uId').then((value) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
          (route) => false,
        );
        uId = '';
      });

      emit(SuccessLogoutData());
    }).catchError((error) {
      emit(ErrorLogoutData());
    });
  }

  int currentIndex = 0;

  void ChangeIndex(int index) {
    if (index == 1) {
      getAllUsers();
    }
    if (index == 2) {
      emit(PostState());
    } else {
      currentIndex = index;
      emit(ChangeIndexState());
    }
  }

  List<Widget> screens = [
    const HomeScreen(),
    const ChatsScreen(),
    NewPostScreen(),
    const UsersScreen(),
    const ScreenScreen(),
  ];

  File? profileImage;
  final picker = ImagePicker();

  Future<void> getProfileData() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(ProfilePikerSuccessState());
    } else {
      print('no Image ????');
      emit(ProfilePikerErrorState());
    }
  }

  File? coverImage;

  Future<void> getCoverData() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(CoverPikerSuccessState());
    } else {
      print('no Image ????');
      emit(CoverPikerErrorState());
    }
  }

  void updateUserText({
    required String bio,
    required String name,
    required String phone,
    String? profileUrl,
    String? coverUrl,
  }) async {
    SocialModel socialModel = SocialModel(
      email: userData!.email,
      name: name,
      phone: phone,
      image: profileUrl ?? userData!.image,
      uId: userData!.uId,
      bio: bio,
      cover: coverUrl ?? userData!.cover,
      isVar: false,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(userData!.uId)
        .update(socialModel.toJson())
        .then((value) {
      getUserData();
    }).onError((error, stackTrace) {
      emit(UpdateTextErrorState());
    });
  }

  void uploadProfile({
    required String bio,
    required String name,
    required String phone,
  }) {
    emit(LoadingUploadProfileUrl());
    storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((p0) {
      p0.ref.getDownloadURL().then((value) {
        updateUserText(
          bio: bio,
          name: name,
          phone: phone,
          profileUrl: value,
        );

        emit(SuccessUploadProfileUrl());
      }).onError((error, stackTrace) {
        print(error);
        emit(ErrorUploadProfileUrl());
      });
    }).onError((error, stackTrace) {
      print(error);
      emit(ErrorUploadProfileUrl());
    });
  }

  void uploadCover({
    required String bio,
    required String name,
    required String phone,
  }) {
    emit(LoadingUploadCoverUrl());
    storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((p0) {
      p0.ref.getDownloadURL().then((value) {
        updateUserText(
          bio: bio,
          name: name,
          phone: phone,
          coverUrl: value,
        );

        emit(SuccessUploadCoverUrl());
      }).onError((error, stackTrace) {
        print(error);
        emit(ErrorUploadCoverUrl());
      });
    }).onError((error, stackTrace) {
      print(error);
      emit(ErrorUploadCoverUrl());
    });
  }

  File? postImage;

  Future<void> getPostImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(PostsPikerSuccessState());
    } else {
      print('no Image ????');
      emit(PostsPikerErrorState());
    }
  }

  void removePostImage() {
    postImage = null;
    emit(RemovePostImageState());
  }

  void uploadPost({
    required String text,
  }) {
    emit(LoadingUploadPosts());
    storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((p0) {
      p0.ref.getDownloadURL().then((value) {
        createPosts(imagePost: value, text: text);

        emit(SuccessUploadPosts());
      }).onError((error, stackTrace) {
        print(error);
        emit(ErrorUploadPosts());
      });
    }).onError((error, stackTrace) {
      print(error);
      emit(ErrorUploadPosts());
    });
  }

  PostModel? postModel;

  void createPosts({
    String? imagePost,
    required String text,
  }) {
    emit(LoadingCreatePosts());
    postModel = PostModel(
      name: userData!.name,
      time: DateTime.now().toString(),
      image: userData!.image,
      uId: userData!.uId,
      imagePost: imagePost ?? '',
      text: text,
      like: false,
    );

    FirebaseFirestore.instance
        .collection('posts')
        .add(postModel!.toJson())
        .then((value) {
      emit(SuccessCreatePosts());
    }).onError((error, stackTrace) {
      print(error);
      emit(ErrorCreatePosts());
    });
  }

  String postIdTest = '';

  void getIdPostsTest(String id) {
    postIdTest = id;
    emit(GetIdPostsTest());
  }

  List<PostModel> posts = [];
  List<CommentModel> postsComment = [];
  List<String> postsId = [];
  List<int> postsLikes = [];
  List<int> postsCommentCount = [];

  void getPosts() {
    emit(LoadingGetPosts());
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy(
          'time',
          descending: true,
        )
        .get()
        .then((value) {
      for (var element in value.docs) {
        element.reference.collection('likes').get().then((value) {
          postsLikes.add(value.docs.length);
          posts.add(PostModel.fromJson(element.data()));
          postsId.add(element.id);
        });
        element.reference.collection('comments').get().then((value) {
          for (var element in value.docs) {
            postsCommentCount.add(value.docs.length);
            postsComment.add(CommentModel.fromJson(element.data()));
          }
        });
      }
      emit(SuccessGetPosts());
    }).onError((error, stackTrace) {
      print(error);
      emit(ErrorGetPosts());
    });
  }

  bool isLiked = false;

  void likePost(String postId, index) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .get()
        .then((value) {
      for (var element in value.docs) {
        if (element.id == userData!.uId) {
          isLiked = true;
        }
      }
      print(isLiked);
      if (isLiked) {
        FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .collection('likes')
            .doc(userData!.uId)
            .delete()
            .then((value) {
          // posts[index].like = false;
          isLiked = false;
          FirebaseFirestore.instance
              .collection('posts')
              .doc(postId)
              .get()
              .then((value) {
            value.reference.update({
              'like': false,
            });
          });

          emit(SuccessLikePosts());
        }).onError((error, stackTrace) {
          print(error);
          isLiked = false;

          emit(ErrorLikePosts());
        });
      } else {
        FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .collection('likes')
            .doc(userData!.uId)
            .set({
          'like': true,
        }).then((value) {
          // posts[index].like = true;

          FirebaseFirestore.instance
              .collection('posts')
              .doc(postId)
              .get()
              .then((value) {
            value.reference.update({
              'like': true,
            });
          });
          // posts[index].like = true;
          emit(SuccessLikePosts());
        }).onError((error, stackTrace) {
          print(error);
          emit(ErrorLikePosts());
        });
      }
    }).onError((error, stackTrace) {
      print(error);
      emit(ErrorLikePosts());
    });
  }

  bool isComment = false;
  CommentModel? commentModel;

  void commentPost({
    required String postId,
    required String text,
  }) {
    isComment = true;
    emit(LoadingCommentPosts());
    commentModel = CommentModel(
      name: userData!.name,
      image: userData!.image,
      text: text,
      time: DateFormat('MMM d, hh:mm aaa').format(DateTime.now()),
      uId: userData!.uId,
    );
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add(commentModel!.toJson())
        .then((value) {
      isComment = false;
      emit(SuccessCommentPosts());
    }).onError((error, stackTrace) {
      print(error);
      isComment = false;
      emit(ErrorCommentPosts());
    });
  }

  List<SocialModel> users = [];

  void getAllUsers() {
    if (users.isEmpty) {
      emit(LoadingGetAllUsers());
      FirebaseFirestore.instance.collection('users').get().then((value) {
        for (var element in value.docs) {
          if (element.data()['uId'] != userData!.uId) {
            users.add(SocialModel.fromJson(element.data()));
          }
        }
        emit(SuccessGetAllUsers());
      }).onError((error, stackTrace) {
        print(error);
        emit(ErrorGetAllUsers());
      });
    }
  }

  void sendMessage({
    required String receiverId,
    required String text,
  }) {
    emit(LoadingSendMessage());
    MessageModel messageModel = MessageModel(
      receiverId: receiverId,
      senderId: userData!.uId,
      text: text,
      dateTime: DateTime.now().toString(),
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(userData!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(
          messageModel.toMap(),
        )
        .then((value) {
      emit(SuccessSendMessage());
    }).catchError((error) {
      print(error);
      emit(ErrorSendMessage());
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userData!.uId)
        .collection('messages')
        .add(
          messageModel.toMap(),
        )
        .then((value) {
      emit(SuccessSendMessage());
    }).catchError((error) {
      print(error);
      emit(ErrorSendMessage());
    });
  }
 int currentIndexChat = 0;
  void changeIndex(int index) {
    currentIndexChat = index;
    emit(ChangeIndexx());
  }
  List<MessageModel> messages = [];

  void getMessage({
    required String receiverId,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userData!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages').orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
      for (var element in event.docs.reversed) {
        messages.add(MessageModel.fromJson(element.data()));
      }
      emit(SuccessGetMessage());
    });
  }
}
