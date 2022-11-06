abstract class SocialState {}

class InitialState_ extends SocialState {}

class SuccessLogoutData extends SocialState {}

class ErrorLogoutData extends SocialState {}

class ChangeIndexState extends SocialState {}

class PostState extends SocialState {}

class ProfilePikerSuccessState extends SocialState {}

class ProfilePikerErrorState extends SocialState {}

class CoverPikerSuccessState extends SocialState {}

class CoverPikerErrorState extends SocialState {}

class PostsPikerSuccessState extends SocialState {}

class PostsPikerErrorState extends SocialState {}

class RemovePostImageState extends SocialState {}

class UpdateTextErrorState extends SocialState {}

class UpdateTextSuccessState extends SocialState {}

class NavigatorPop extends SocialState {}

class CoverikerSuccessState extends SocialState {}

class CoverikerErrorState extends SocialState {}

class LoadingGetUserData extends SocialState {}

class SuccessGetUserData extends SocialState {}

class ErrorGetUserData extends SocialState {
  final String message;

  ErrorGetUserData(this.message);
}

class ErrorUploadProfileUrl extends SocialState {}

class SuccessUploadProfileUrl extends SocialState {}

class LoadingUploadProfileUrl extends SocialState {}

class ErrorUploadCoverUrl extends SocialState {}

class LoadingUploadCoverUrl extends SocialState {}

class SuccessUploadCoverUrl extends SocialState {}

class ErrorUploadPosts extends SocialState {}

class LoadingUploadPosts extends SocialState {}

class SuccessUploadPosts extends SocialState {}

class SuccessCreatePosts extends SocialState {}

class ErrorCreatePosts extends SocialState {}

class LoadingCreatePosts extends SocialState {}

class LoadingGetPosts extends SocialState {}

class SuccessGetPosts extends SocialState {}

class ErrorGetPosts extends SocialState {}

class SuccessLikePosts extends SocialState {}

class ErrorLikePosts extends SocialState {}

class SuccessGetSecond extends SocialState {}

class LoadingLikePosts extends SocialState {}

class SuccessUnlikePosts extends SocialState {}

class ErrorUnlikePosts extends SocialState {}

class LoadingUnlikePosts extends SocialState {}

class SuccessCommentPosts extends SocialState {}

class ErrorCommentPosts extends SocialState {}

class LoadingCommentPosts extends SocialState {}

class GetIdPostsTest extends SocialState {}

class SuccessDeletePosts extends SocialState {}

class ErrorDeletePosts extends SocialState {}

class ChangeLikeFast extends SocialState {}

class LoadingGetAllUsers extends SocialState {}

class SuccessGetAllUsers extends SocialState {}

class ErrorGetAllUsers extends SocialState {}

class LoadingSendMessage extends SocialState {}

class SuccessSendMessage extends SocialState {}

class SuccessGetMessage extends SocialState {}

class ErrorSendMessage extends SocialState {}
class ChangeIndexx extends SocialState {}
