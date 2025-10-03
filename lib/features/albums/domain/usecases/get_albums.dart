import 'package:injectable/injectable.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/album.dart';
import '../repositories/albums_repository.dart';

@LazySingleton()
class GetAlbumsUseCase implements UseCase<List<Album>, NoParams> {
  GetAlbumsUseCase(this._repository);
  final AlbumsRepository _repository;
  @override
  Future<List<Album>> call(NoParams params) => _repository.getAlbums();
}
