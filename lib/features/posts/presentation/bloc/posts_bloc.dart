import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../posts/domain/entities/post.dart';
import '../../../posts/domain/usecases/get_posts.dart';

part 'posts_bloc.freezed.dart';
part 'posts_event.dart';
part 'posts_state.dart';

@injectable
class PostsBloc extends Bloc<PostsEvent, PostsState> {
  PostsBloc(this._getPosts) : super(const PostsState()) {
    on<_Started>((event, emit) async {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      try {
        final List<Post> posts = await _getPosts(const NoParams());
        emit(state.copyWith(isLoading: false, posts: posts));
      } catch (e) {
        emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      }
    });
  }

  final GetPostsUseCase _getPosts;
}
