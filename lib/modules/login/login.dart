import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_app/cubit/social_cubit/cubit_shop.dart';
import 'package:social_app/layout/social_layout.dart';
import 'package:social_app/modules/login/register.dart';
import '../../cubit/login_cubit/cubit.dart';
import '../../cubit/login_cubit/states.dart';
import '../../network/cache_helper.dart';
import '../../shared/component.dart';

var controllerEmail = TextEditingController();
var controllerPassword = TextEditingController();
var keyForm = GlobalKey<FormState>();

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
         if (state is LoginSuccessState) {
             CacheHelper.saveData(
                     key: 'uId',
                 value: state.uId)
                 .then((value) {
               uId =  state.uId;
                   Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SocialLayout(),
                    ),
                    (route) => false);
                   SocialCubit.get(context).getUserData();
             });
             controllerEmail.clear();
              controllerPassword.clear();
           }

        if(state is LoginErrorState){
          Fluttertoast.showToast(
              msg: state.message,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 5,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 15.0) ;
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: keyForm,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LOGIN',
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            ?.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Welcome to Social App',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            ?.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(

                        controller: controllerEmail,
                        onFieldSubmitted: (value) {
                          if (keyForm.currentState!.validate()) {
                            // ShopLoginCubit.get(context).userLogin(
                            //     email: controllerEmail.text,
                            //     password: controllerPassword.text);

                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email_outlined),
                          labelText: 'Email',
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: controllerPassword,
                        obscureText: LoginCubit.get(context).isPass,
                        onFieldSubmitted: (value) {
                          if (keyForm.currentState!.validate()) {
                            LoginCubit.get(context).loginUser(
                                email: controllerEmail.text,
                                password: controllerPassword.text);
                          }
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            onPressed: () {
                              LoginCubit.get(context)
                                  .changeVisibilityPass();
                            },
                            icon: Icon(LoginCubit.get(context).icon),
                          ),
                          labelText: 'Password',
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ConditionalBuilder(
                        condition: state is! LoginLoadingState,
                        builder: (context) => Container(
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: MaterialButton(
                            onPressed: () {
                              if (keyForm.currentState!.validate()) {
                                LoginCubit.get(context).loginUser(
                                    email: controllerEmail.text,
                                    password: controllerPassword.text);
                              }
                            },
                            child: const Text(
                              'LOGIN',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        fallback: (context) => const Center(
                            child: CircularProgressIndicator()),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Don\'t have an account? ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const RegisterScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Sign up',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
