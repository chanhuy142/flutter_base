// Run with:  fvm flutter pub run tool/generate_module.dart <module_name>
// Example:   fvm flutter pub run tool/generate_module.dart comments

import 'dart:io';

import 'package:recase/recase.dart';

void main(List<String> args) async {
  if (args.isEmpty) {
    stderr.writeln('Usage: generate_module <module_name>');
    exitCode = 64; // EX_USAGE
    return;
  }

  final String rawName = args.first;
  final ReCase rc = ReCase(rawName);
  final String feature = rc.snakeCase; // e.g., comments
  final String classBase = rc.pascalCase; // e.g., Comments
  final ReCase singular = _singular(rc);
  final String entityName = singular.pascalCase; // e.g., Comment

  // Ensure feature directory exists (created implicitly when writing files)
  final List<FileWrite> files = [
    // Domain
    FileWrite(
      'lib/features/$feature/domain/entities/${singular.snakeCase}.dart',
      _entityTemplate(entityName),
    ),
    FileWrite(
      'lib/features/$feature/domain/repositories/${feature}_repository.dart',
      _repositoryTemplate(feature, classBase, singular),
    ),
    FileWrite(
      'lib/features/$feature/domain/usecases/get_$feature.dart',
      _usecaseTemplate(feature, classBase, entityName, singular),
    ),
    // Data
    FileWrite(
      'lib/features/$feature/data/models/${singular.snakeCase}_model.dart',
      _modelTemplate(entityName, singular),
    ),
    FileWrite(
      'lib/features/$feature/data/datasources/${feature}_remote_data_source.dart',
      _remoteDataSourceTemplate(feature, classBase, entityName, singular),
    ),
    FileWrite(
      'lib/features/$feature/data/repositories/${feature}_repository_impl.dart',
      _repositoryImplTemplate(feature, classBase, entityName, singular),
    ),
    // Presentation
    FileWrite(
      'lib/features/$feature/presentation/bloc/${feature}_bloc.dart',
      _blocTemplate(feature, classBase, entityName, singular),
    ),
    FileWrite(
      'lib/features/$feature/presentation/bloc/${feature}_event.dart',
      _eventTemplate(feature, classBase),
    ),
    FileWrite(
      'lib/features/$feature/presentation/bloc/${feature}_state.dart',
      _stateTemplate(feature, classBase, entityName),
    ),
    FileWrite(
      'lib/features/$feature/presentation/pages/${feature}_page.dart',
      _pageTemplate(feature, classBase),
    ),
  ];

  for (final FileWrite fw in files) {
    final File f = File(fw.path);
    await f.parent.create(recursive: true);
    if (!await f.exists()) {
      await f.writeAsString(fw.content);
      stdout.writeln('Created ${fw.path}');
    } else {
      stdout.writeln('Skipped ${fw.path} (exists)');
    }
  }

  // Also update app router with a route to the generated page
  await _updateRouter(feature: feature, classBase: classBase);

  stdout.writeln('Done. Next: run build_runner and wire navigation if needed.');
}

class FileWrite {
  FileWrite(this.path, this.content);
  final String path;
  final String content;
}

ReCase _singular(ReCase rc) {
  // naive singularization: drop trailing 's' if present
  final String word = rc.camelCase;
  if (word.isNotEmpty && word.endsWith('s')) {
    return ReCase(word.substring(0, word.length - 1));
  }
  return rc;
}

Future<void> _updateRouter({required String feature, required String classBase}) async {
  final File routerFile = File('lib/core/router/app_router.dart');
  if (!await routerFile.exists()) {
    stderr.writeln('Router file not found at lib/core/router/app_router.dart. Skipped routing update.');
    return;
  }

  String content = await routerFile.readAsString();

  // 1) Ensure import exists
  final String importLine = "import '../../features/$feature/presentation/pages/${feature}_page.dart';";
  if (!content.contains(importLine)) {
    // Insert after the last existing import line
    final RegExp importBlock = RegExp(r"(^import .+;\s*$)+", multiLine: true);
    final Iterable<RegExpMatch> matches = importBlock.allMatches(content);
    if (matches.isNotEmpty) {
      final RegExpMatch last = matches.last;
      final int insertIndex = last.end;
      content = content.substring(0, insertIndex) + '\n' + importLine + content.substring(insertIndex);
    } else {
      // Fallback: prepend at top
      content = importLine + '\n' + content;
    }
  }

  // 2) Ensure route exists
  final String routeSnippet =
      "    GoRoute(\n"
      "      path: '/$feature',\n"
      "      name: '$feature',\n"
      "      builder: (context, state) => const ${classBase}Page(),\n"
      "    ),\n";

  if (!content.contains("name: '$feature'")) {
    // Insert before closing of routes list: \n  ],\n or \n  ]
    final int routesStart = content.indexOf('routes: <GoRoute>[');
    if (routesStart != -1) {
      final int closingIndex = content.indexOf('],', routesStart);
      final int fallbackClosing = content.indexOf(']\n', routesStart);
      int insertAt = closingIndex != -1 ? closingIndex : fallbackClosing;
      if (insertAt == -1) {
        // Fallback: try last bracket
        insertAt = content.lastIndexOf(']');
      }
      if (insertAt != -1) {
        content = content.substring(0, insertAt) + routeSnippet + content.substring(insertAt);
      } else {
        stderr.writeln('Could not locate routes list to insert new route.');
      }
    } else {
      stderr.writeln('Could not find routes list in router file.');
    }
  }

  await routerFile.writeAsString(content);
  stdout.writeln('Updated router with /$feature route.');
}

String _entityTemplate(String entity) =>
    """
import 'package:freezed_annotation/freezed_annotation.dart';

part '${entity.toLowerCase()}.freezed.dart';

@freezed
abstract class $entity with _\$$entity {
  const factory $entity({
    required int id,
  }) = _$entity;
}
""";

String _repositoryTemplate(String feature, String classBase, ReCase singular) =>
    """
import '../entities/${singular.snakeCase}.dart';

abstract class ${classBase}Repository {
  Future<List<${singular.pascalCase}>> get$classBase();
}
""";

String _usecaseTemplate(String feature, String classBase, String entity, ReCase singular) =>
    """
import 'package:injectable/injectable.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/${singular.snakeCase}.dart';
import '../repositories/${feature}_repository.dart';

@LazySingleton()
class Get${classBase}UseCase implements UseCase<List<$entity>, NoParams> {
  Get${classBase}UseCase(this._repository);
  final ${classBase}Repository _repository;
  @override
  Future<List<$entity>> call(NoParams params) => _repository.get$classBase();
}
""";

String _modelTemplate(String entity, ReCase singular) =>
    """
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/${singular.snakeCase}.dart';

part '${singular.snakeCase}_model.freezed.dart';
part '${singular.snakeCase}_model.g.dart';

@freezed
abstract class ${singular.pascalCase}Model with _\$${singular.pascalCase}Model {
  const factory ${singular.pascalCase}Model({
    required int id,
  }) = _${singular.pascalCase}Model;

  factory ${singular.pascalCase}Model.fromJson(Map<String, dynamic> json) => _\$${singular.pascalCase}ModelFromJson(json);
}

extension ${singular.pascalCase}ModelMapping on ${singular.pascalCase}Model {
  $entity toEntity() => $entity(id: id);
}
""";

String _remoteDataSourceTemplate(String feature, String classBase, String entity, ReCase singular) =>
    """
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../models/${singular.snakeCase}_model.dart';

abstract class ${classBase}RemoteDataSource {
  Future<List<${singular.pascalCase}Model>> fetch${feature.pascalCase}();
}

@LazySingleton(as: ${classBase}RemoteDataSource)
class ${classBase}RemoteDataSourceImpl implements ${classBase}RemoteDataSource {
  ${classBase}RemoteDataSourceImpl(this._dio);
  final Dio _dio;
  @override
  Future<List<${singular.pascalCase}Model>> fetch${feature.pascalCase}() async {
    final Response<dynamic> response = await _dio.get('/$feature');
    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((dynamic e) => ${singular.pascalCase}Model.fromJson(e as Map<String, dynamic>)).toList(growable: false);
  }
}
""";

String _repositoryImplTemplate(String feature, String classBase, String entity, ReCase singular) =>
    """
import 'package:injectable/injectable.dart';
import '../../domain/entities/${singular.snakeCase}.dart';
import '../../domain/repositories/${feature}_repository.dart';
import '../datasources/${feature}_remote_data_source.dart';
import '../models/${singular.snakeCase}_model.dart';

@LazySingleton(as: ${classBase}Repository)
class ${classBase}RepositoryImpl implements ${classBase}Repository {
  ${classBase}RepositoryImpl(this._remote);
  final ${classBase}RemoteDataSource _remote;

  @override
  Future<List<$entity>> get$classBase() async {
    final List<${singular.pascalCase}Model> models = await _remote.fetch${feature.pascalCase}();
    return models.map((e) => e.toEntity()).toList(growable: false);
  }
}
""";

String _blocTemplate(String feature, String classBase, String entity, ReCase singular) =>
    """
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/${singular.snakeCase}.dart';
import '../../domain/usecases/get_$feature.dart';
import '../../../../core/usecase/usecase.dart';

part '${feature}_bloc.freezed.dart';
part '${feature}_event.dart';
part '${feature}_state.dart';

@injectable
class ${classBase}Bloc extends Bloc<${classBase}Event, ${classBase}State> {
  ${classBase}Bloc(this._get) : super(const ${classBase}State.initial()) {
    on<_Started>((event, emit) async {
      emit(const ${classBase}State.loading());
      try {
        final List<$entity> data = await _get(const NoParams());
        emit(${classBase}State.success(data));
      } catch (e) {
        emit(${classBase}State.failure(e.toString()));
      }
    });
  }
  final Get${classBase}UseCase _get;
}
""";

String _eventTemplate(String feature, String classBase) =>
    """
part of '${feature}_bloc.dart';

@freezed
class ${classBase}Event with _\$${classBase}Event {
  const factory ${classBase}Event.started() = _Started;
}
""";

String _stateTemplate(String feature, String classBase, String entity) =>
    """
part of '${feature}_bloc.dart';

@freezed
class ${classBase}State with _\$${classBase}State {
  const factory ${classBase}State.initial() = _Initial;
  const factory ${classBase}State.loading() = _Loading;
  const factory ${classBase}State.success(List<$entity> data) = _Success;
  const factory ${classBase}State.failure(String message) = _Failure;
}
""";

String _pageTemplate(String feature, String classBase) =>
    """
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../bloc/${feature}_bloc.dart';

class ${classBase}Page extends StatelessWidget {
  const ${classBase}Page({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider<${classBase}Bloc>(
      create: (_) => getIt<${classBase}Bloc>()..add(const ${classBase}Event.started()),
      child: Scaffold(
        appBar: AppBar(title: const Text('$classBase')),
        body: BlocBuilder<${classBase}Bloc, ${classBase}State>(
          builder: (context, state) {
            return state.when(
              initial: () => const SizedBox.shrink(),
              loading: () => const Center(child: CircularProgressIndicator()),
              success: (items) => ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, idx) => ListTile(title: Text(items[idx].toString())),
              ),
              failure: (msg) => Center(child: Text('Error: \$msg')),
            );
          },
        ),
      ),
    );
  }
}
""";


