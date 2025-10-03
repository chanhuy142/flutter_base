import '../entities/comment.dart';

abstract class CommentsRepository {
  Future<List<Comment>> getComments();
}
