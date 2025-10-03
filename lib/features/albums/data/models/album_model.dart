import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/album.dart';

part 'album_model.freezed.dart';
part 'album_model.g.dart';

@freezed
abstract class AlbumModel with _$AlbumModel {
  const factory AlbumModel({
    required int id,
  }) = _AlbumModel;

  factory AlbumModel.fromJson(Map<String, dynamic> json) => _$AlbumModelFromJson(json);
}

extension AlbumModelMapping on AlbumModel {
  Album toEntity() => Album(id: id);
}
