import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


void showToast ({
  required String message,
  required ToastState state,
}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: ChangeColor(state),
      textColor: Colors.white,
      fontSize: 16.0);
}
enum ToastState {SUCCESS, ERROR , WARNING}

Color ? color_ ;
Color? ChangeColor (ToastState state) {
  switch (state) {
    case ToastState.SUCCESS:
      color_ = Colors.green;
      break;
    case ToastState.ERROR:
      color_ =  Colors.red;
      break;
    case ToastState.WARNING:
      color_ =  Colors.yellow;
      break;
  }
  return color_;
}

// void signOut (context) {
//
//   CacheHelper.removeData(key: 'token').then((value) {
//     if (value) {
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const LoginScreen(),
//         ),
//             (route) => false,
//       );
//     }
//   });
// }

void printFullText (String text) {
  final pattern = RegExp('.{1,800}');
  pattern.allMatches(text).forEach((match) {
    print(match.group(0));
  });
}

String ? uId ='';

 //ShopLoginModel? UserDatas;
