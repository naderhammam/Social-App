import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/model/social_model.dart';
import 'package:social_app/shared/component.dart';
import '../../network/cache_helper.dart';
import 'states.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(InitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  void loginUser({required String email, required String password}) {
    emit(LoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((user) {
      print(user.user!.email);
      emit(LoginSuccessState(
        uId: user.user!.uid,
      ));
    }).catchError((error) {
      emit(LoginErrorState(message: error.toString()));
    });
  }

  void registerUser({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) {
    emit(LoadingRegisterData());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      uId = value.user!.uid;

      createUser(
        email: email,
        name: name,
        phone: phone,
        uId: value.user!.uid,
      );
      CacheHelper.saveData(
        key: 'uId',
        value: value.user!.uid,
      );
    }).onError((error, stackTrace) {
      print(error.toString());
      emit(ErrorRegisterData(error.toString()));
    });
  }

  void createUser({
    required String email,
    required String name,
    required String phone,
    required String uId,
  }) {
    SocialModel socialModel = SocialModel(
      email: email,
      name: name,
      phone: phone,
      image:
          'https://img.freepik.com/free-vector/alien-head-with-glitch-effect_225004-653.jpg?w=740&t=st=1660399818~exp=1660400418~hmac=936bc092808e1a30b28870d6c603196f4b37fbd4f36389a0c5adef7936b25a6a',
      uId: uId,
      bio: 'write your bio ...',
      cover:
          'https://img.freepik.com/free-vector/ufo-light-beams-glowing-rays-from-alien-spaceships-night_107791-4460.jpg?w=1060&t=st=1660400746~exp=1660401346~hmac=8b6e7612e9465fc7a50f3e424a1b1eefa3673d47a624319e593d44fb7f0d1601',
      isVar: false,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(
          socialModel.toJson(),
        )
        .then((value) {
      emit(SuccessCreateData());
    }).onError((error, stackTrace) {
      print(error.toString());
      emit(ErrorCreateData(error.toString()));
    });
  }

  bool isPass = true;
  IconData icon = Icons.visibility_outlined;
  void changeVisibilityPass() {
    isPass = !isPass;
    icon = isPass ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(ChangePassVisibilityState());
  }

  bool isPassReg = true;
  IconData iconReg = Icons.visibility_outlined;
  void changeRegVisibilityPass() {
    isPassReg = !isPassReg;
    print(isPassReg);
    iconReg =
        isPassReg ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(ChangeRegPassVisibilityState());
  }
}
