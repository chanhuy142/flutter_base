// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:match/core/network/dio_module.dart' as _i997;
import 'package:match/features/albums/data/datasources/albums_remote_data_source.dart'
    as _i245;
import 'package:match/features/albums/data/repositories/albums_repository_impl.dart'
    as _i972;
import 'package:match/features/albums/domain/repositories/albums_repository.dart'
    as _i146;
import 'package:match/features/albums/domain/usecases/get_albums.dart' as _i54;
import 'package:match/features/albums/presentation/bloc/albums_bloc.dart'
    as _i98;
import 'package:match/features/comments/data/datasources/comments_remote_data_source.dart'
    as _i957;
import 'package:match/features/comments/data/repositories/comments_repository_impl.dart'
    as _i285;
import 'package:match/features/comments/domain/repositories/comments_repository.dart'
    as _i583;
import 'package:match/features/comments/domain/usecases/get_comments.dart'
    as _i849;
import 'package:match/features/comments/presentation/bloc/comments_bloc.dart'
    as _i950;
import 'package:match/features/posts/data/datasources/posts_remote_data_source.dart'
    as _i99;
import 'package:match/features/posts/data/repositories/posts_repository_impl.dart'
    as _i606;
import 'package:match/features/posts/domain/repositories/posts_repository.dart'
    as _i122;
import 'package:match/features/posts/domain/usecases/get_posts.dart' as _i708;
import 'package:match/features/posts/presentation/bloc/posts_bloc.dart'
    as _i302;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final networkModule = _$NetworkModule();
    gh.lazySingleton<_i361.Dio>(() => networkModule.dio());
    gh.lazySingleton<_i957.CommentsRemoteDataSource>(
      () => _i957.CommentsRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i245.AlbumsRemoteDataSource>(
      () => _i245.AlbumsRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i583.CommentsRepository>(
      () => _i285.CommentsRepositoryImpl(gh<_i957.CommentsRemoteDataSource>()),
    );
    gh.lazySingleton<_i99.PostsRemoteDataSource>(
      () => _i99.PostsRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i146.AlbumsRepository>(
      () => _i972.AlbumsRepositoryImpl(gh<_i245.AlbumsRemoteDataSource>()),
    );
    gh.lazySingleton<_i849.GetCommentsUseCase>(
      () => _i849.GetCommentsUseCase(gh<_i583.CommentsRepository>()),
    );
    gh.factory<_i950.CommentsBloc>(
      () => _i950.CommentsBloc(gh<_i849.GetCommentsUseCase>()),
    );
    gh.lazySingleton<_i122.PostsRepository>(
      () => _i606.PostsRepositoryImpl(gh<_i99.PostsRemoteDataSource>()),
    );
    gh.lazySingleton<_i54.GetAlbumsUseCase>(
      () => _i54.GetAlbumsUseCase(gh<_i146.AlbumsRepository>()),
    );
    gh.lazySingleton<_i708.GetPostsUseCase>(
      () => _i708.GetPostsUseCase(gh<_i122.PostsRepository>()),
    );
    gh.factory<_i302.PostsBloc>(
      () => _i302.PostsBloc(gh<_i708.GetPostsUseCase>()),
    );
    gh.factory<_i98.AlbumsBloc>(
      () => _i98.AlbumsBloc(gh<_i54.GetAlbumsUseCase>()),
    );
    return this;
  }
}

class _$NetworkModule extends _i997.NetworkModule {}
