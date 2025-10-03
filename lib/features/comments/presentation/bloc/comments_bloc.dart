import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/comment.dart';
import '../../domain/usecases/get_comments.dart';
import '../../../../core/usecase/usecase.dart';

part 'comments_bloc.freezed.dart';
part 'comments_event.dart';
part 'comments_state.dart';

@injectable
class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  CommentsBloc(this._get) : super(const CommentsState.initial()) {
    on<_Started>((event, emit) async {
      emit(const CommentsState.loading());
      try {
        final List<Comment> data = await _get(const NoParams());
        emit(CommentsState.success(data));
      } catch (e) {
        emit(CommentsState.failure(e.toString()));
      }
    });
  }
  final GetCommentsUseCase _get;
}
