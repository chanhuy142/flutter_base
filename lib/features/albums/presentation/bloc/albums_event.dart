part of 'albums_bloc.dart';

@freezed
class AlbumsEvent with _$AlbumsEvent {
  const factory AlbumsEvent.started() = _Started;
}
