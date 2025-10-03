import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/album.dart';
import '../../domain/usecases/get_albums.dart';
import '../../../../core/usecase/usecase.dart';

part 'albums_bloc.freezed.dart';
part 'albums_event.dart';
part 'albums_state.dart';

@injectable
class AlbumsBloc extends Bloc<AlbumsEvent, AlbumsState> {
  AlbumsBloc(this._get) : super(const AlbumsState.initial()) {
    on<_Started>((event, emit) async {
      emit(const AlbumsState.loading());
      try {
        final List<Album> data = await _get(const NoParams());
        emit(AlbumsState.success(data));
      } catch (e) {
        emit(AlbumsState.failure(e.toString()));
      }
    });
  }
  final GetAlbumsUseCase _get;
}
