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
import 'package:match/core/di/register_module.module.dart' as _i270;
import 'package:match/core/network/dio_module.dart' as _i997;
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
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    await _i270.MatchPackageModule().init(gh);
    final networkModule = _$NetworkModule();
    gh.lazySingleton<_i361.Dio>(() => networkModule.dio());
    gh.lazySingleton<_i99.PostsRemoteDataSource>(
      () => _i99.PostsRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i122.PostsRepository>(
      () => _i606.PostsRepositoryImpl(gh<_i99.PostsRemoteDataSource>()),
    );
    gh.lazySingleton<_i708.GetPostsUseCase>(
      () => _i708.GetPostsUseCase(gh<_i122.PostsRepository>()),
    );
    gh.factory<_i302.PostsBloc>(
      () => _i302.PostsBloc(gh<_i708.GetPostsUseCase>()),
    );
    return this;
  }
}

class _$NetworkModule extends _i997.NetworkModule {}
