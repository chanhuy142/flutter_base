part of 'comments_bloc.dart';

@freezed
class CommentsState with _$CommentsState {
  const factory CommentsState.initial() = _Initial;
  const factory CommentsState.loading() = _Loading;
  const factory CommentsState.success(List<Comment> data) = _Success;
  const factory CommentsState.failure(String message) = _Failure;
}
