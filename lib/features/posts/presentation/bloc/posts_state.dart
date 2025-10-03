part of 'posts_bloc.dart';

@freezed
abstract class PostsState with _$PostsState {
  const factory PostsState({
    @Default(<Post>[]) List<Post> posts,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _PostsState;
}
