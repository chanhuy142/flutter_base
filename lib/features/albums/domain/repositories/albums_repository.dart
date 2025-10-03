import '../entities/album.dart';

abstract class AlbumsRepository {
  Future<List<Album>> getAlbums();
}
