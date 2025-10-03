import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@module
abstract class NetworkModule {
  @lazySingleton
  Dio dio() {
    final BaseOptions options = BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      contentType: 'application/json; charset=utf-8',
    );
    final Dio client = Dio(options);
    return client;
  }
}



