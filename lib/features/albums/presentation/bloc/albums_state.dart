part of 'albums_bloc.dart';

@freezed
class AlbumsState with _$AlbumsState {
  const factory AlbumsState.initial() = _Initial;
  const factory AlbumsState.loading() = _Loading;
  const factory AlbumsState.success(List<Album> data) = _Success;
  const factory AlbumsState.failure(String message) = _Failure;
}
