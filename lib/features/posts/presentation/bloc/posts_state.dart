part of 'posts_bloc.dart';

@freezed
class PostsState with _$PostsState {
  const factory PostsState.initial() = _Initial;
  const factory PostsState.loading() = _Loading;
  const factory PostsState.success(List<Post> posts) = _Success;
  const factory PostsState.failure(String message) = _Failure;
}



