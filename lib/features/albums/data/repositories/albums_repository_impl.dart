import 'package:injectable/injectable.dart';
import '../../domain/entities/album.dart';
import '../../domain/repositories/albums_repository.dart';
import '../datasources/albums_remote_data_source.dart';
import '../models/album_model.dart';

@LazySingleton(as: AlbumsRepository)
class AlbumsRepositoryImpl implements AlbumsRepository {
  AlbumsRepositoryImpl(this._remote);
  final AlbumsRemoteDataSource _remote;

  @override
  Future<List<Album>> getAlbums() async {
    final List<AlbumModel> models = await _remote.fetchAlbums();
    return models.map((e) => e.toEntity()).toList(growable: false);
  }
}
