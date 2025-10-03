import 'package:injectable/injectable.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/comment.dart';
import '../repositories/comments_repository.dart';

@LazySingleton()
class GetCommentsUseCase implements UseCase<List<Comment>, NoParams> {
  GetCommentsUseCase(this._repository);
  final CommentsRepository _repository;
  @override
  Future<List<Comment>> call(NoParams params) => _repository.getComments();
}
