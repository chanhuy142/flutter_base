import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../posts/domain/entities/post.dart';
import '../../../posts/domain/usecases/get_posts.dart';
import '../../../../core/usecase/usecase.dart';

part 'posts_bloc.freezed.dart';
part 'posts_event.dart';
part 'posts_state.dart';

@injectable
class PostsBloc extends Bloc<PostsEvent, PostsState> {
  PostsBloc(this._getPosts) : super(const PostsState.initial()) {
    on<_Started>((event, emit) async {
      emit(const PostsState.loading());
      try {
        final List<Post> posts = await _getPosts(const NoParams());
        emit(PostsState.success(posts));
      } catch (e) {
        emit(PostsState.failure(e.toString()));
      }
    });
  }

  final GetPostsUseCase _getPosts;
}



