import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../models/post_model.dart';

abstract class PostsRemoteDataSource {
  Future<List<PostModel>> fetchPosts();
}

@LazySingleton(as: PostsRemoteDataSource)
class PostsRemoteDataSourceImpl implements PostsRemoteDataSource {
  PostsRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<PostModel>> fetchPosts() async {
    final Response<dynamic> response = await _dio.get('/posts');
    final List<dynamic> data = response.data as List<dynamic>;
    return data
        .map((dynamic e) => PostModel.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
  }
}



