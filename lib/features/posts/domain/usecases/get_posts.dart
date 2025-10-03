import 'package:injectable/injectable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/post.dart';
import '../repositories/posts_repository.dart';

@LazySingleton()
class GetPostsUseCase implements UseCase<List<Post>, NoParams> {
  GetPostsUseCase(this._repository);

  final PostsRepository _repository;

  @override
  Future<List<Post>> call(NoParams params) {
    return _repository.getPosts();
  }
}



