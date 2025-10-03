import 'package:injectable/injectable.dart';

import '../../domain/entities/post.dart';
import '../../domain/repositories/posts_repository.dart';
import '../datasources/posts_remote_data_source.dart';
import '../models/post_model.dart';

@LazySingleton(as: PostsRepository)
class PostsRepositoryImpl implements PostsRepository {
  PostsRepositoryImpl(this._remoteDataSource);

  final PostsRemoteDataSource _remoteDataSource;

  @override
  Future<List<Post>> getPosts() async {
    final List<PostModel> models = await _remoteDataSource.fetchPosts();
    return models.map((PostModel e) => e.toEntity()).toList(growable: false);
  }
}



