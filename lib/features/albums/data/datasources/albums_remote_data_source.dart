import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../models/album_model.dart';

abstract class AlbumsRemoteDataSource {
  Future<List<AlbumModel>> fetchAlbums();
}

@LazySingleton(as: AlbumsRemoteDataSource)
class AlbumsRemoteDataSourceImpl implements AlbumsRemoteDataSource {
  AlbumsRemoteDataSourceImpl(this._dio);
  final Dio _dio;
  @override
  Future<List<AlbumModel>> fetchAlbums() async {
    final Response<dynamic> response = await _dio.get('/albums');
    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((dynamic e) => AlbumModel.fromJson(e as Map<String, dynamic>)).toList(growable: false);
  }
}
