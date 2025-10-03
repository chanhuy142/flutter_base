import 'package:injectable/injectable.dart';
import '../../domain/entities/comment.dart';
import '../../domain/repositories/comments_repository.dart';
import '../datasources/comments_remote_data_source.dart';
import '../models/comment_model.dart';

@LazySingleton(as: CommentsRepository)
class CommentsRepositoryImpl implements CommentsRepository {
  CommentsRepositoryImpl(this._remote);
  final CommentsRemoteDataSource _remote;

  @override
  Future<List<Comment>> getComments() async {
    final List<CommentModel> models = await _remote.fetchComments();
    return models.map((e) => e.toEntity()).toList(growable: false);
  }
}
