
abstract class LoginState {
}

class InitialState extends LoginState {}

class LoginSuccessState extends LoginState {
  var uId;
  LoginSuccessState({required this.uId});
}
class LoginErrorState extends LoginState {
  final String message;
  LoginErrorState({ required this.message});

}
class LoginLoadingState extends LoginState {}

class ChangePassVisibilityState extends LoginState {}
class ChangeRegPassVisibilityState extends LoginState {}

class SuccessRegisterData extends LoginState {}
class ErrorRegisterData extends LoginState {
  final String message;
  ErrorRegisterData(this.message);
}
class LoadingRegisterData extends LoginState {}

class SuccessGetuIdData extends LoginState {}


class SuccessCreateData extends LoginState {}
class ErrorCreateData extends LoginState {
  final String message;
  ErrorCreateData(this.message);
}
