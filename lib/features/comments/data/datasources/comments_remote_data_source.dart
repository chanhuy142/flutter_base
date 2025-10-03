import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../models/comment_model.dart';

abstract class CommentsRemoteDataSource {
  Future<List<CommentModel>> fetchComments();
}

@LazySingleton(as: CommentsRemoteDataSource)
class CommentsRemoteDataSourceImpl implements CommentsRemoteDataSource {
  CommentsRemoteDataSourceImpl(this._dio);
  final Dio _dio;
  @override
  Future<List<CommentModel>> fetchComments() async {
    final Response<dynamic> response = await _dio.get('/comments');
    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((dynamic e) => CommentModel.fromJson(e as Map<String, dynamic>)).toList(growable: false);
  }
}
