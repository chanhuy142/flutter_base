// @dart=3.6
// ignore_for_file: directives_ordering
// build_runner >=2.4.16
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:build_runner/src/build_plan/builder_factories.dart' as _i1;
import 'package:freezed/builder.dart' as _i2;
import 'package:injectable_generator/builder.dart' as _i3;
import 'package:json_serializable/builder.dart' as _i4;
import 'package:source_gen/builder.dart' as _i5;
import 'dart:io' as _i6;
import 'package:build_runner/src/bootstrap/processes.dart' as _i7;

final _builderFactories = _i1.BuilderFactories(
  builderFactories: {
    'freezed:freezed': [_i2.freezed],
    'injectable_generator:injectable_builder': [_i3.injectableBuilder],
    'injectable_generator:injectable_config_builder': [
      _i3.injectableConfigBuilder
    ],
    'json_serializable:json_serializable': [_i4.jsonSerializable],
    'source_gen:combining_builder': [_i5.combiningBuilder],
  },
  postProcessBuilderFactories: {'source_gen:part_cleanup': _i5.partCleanup},
);
void main(List<String> args) async {
  _i6.exitCode = await _i7.ChildProcess.run(
    args,
    _builderFactories,
  )!;
}
