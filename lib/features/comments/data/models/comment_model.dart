import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/comment.dart';

part 'comment_model.freezed.dart';
part 'comment_model.g.dart';

@freezed
abstract class CommentModel with _$CommentModel {
  const factory CommentModel({
    required int id,
  }) = _CommentModel;

  factory CommentModel.fromJson(Map<String, dynamic> json) => _$CommentModelFromJson(json);
}

extension CommentModelMapping on CommentModel {
  Comment toEntity() => Comment(id: id);
}
