// Run with: fvm flutter pub run tool/app_identifier.dart
// Reads app_identifier.yaml and updates Android/iOS/Web names and identifiers.

import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final File configFile = File('app_identifier.yaml');
  if (!await configFile.exists()) {
    stderr.writeln(
      'app_identifier.yaml not found. Skipping identifier update.',
    );
    exit(0);
  }
  final Map<String, dynamic> cfg = _parseYaml(await configFile.readAsString());
  final String? appName = _str(cfg['app_name']);
  final String? androidId = _str(cfg['android_application_id']);
  final String? iosBundleId = _str(cfg['ios_bundle_id']);
  final String? webTitle = _str(cfg['web_title']) ?? appName;

  if (androidId != null) {
    await _updateAndroidIds(androidId);
  }
  // Always ensure AndroidManifest activity points to the real MainActivity package
  await _syncAndroidMainActivityName();
  if (appName != null) {
    await _updateAndroidAppName(appName);
  }

  if (iosBundleId != null) {
    await _updateIosBundleId(iosBundleId);
  }
  if (appName != null) {
    await _updateIosAppName(appName);
  }

  if (webTitle != null) {
    await _updateWebTitle(webTitle);
  }

  stdout.writeln('app_identifier applied successfully.');
}

Map<String, dynamic> _parseYaml(String content) {
  // Minimal YAML parser for simple key: value pairs (no nested objects), to avoid extra deps
  final Map<String, dynamic> out = <String, dynamic>{};
  for (final String line in content.split(RegExp(r'\r?\n'))) {
    final String trimmed = line.trim();
    if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
    final int idx = trimmed.indexOf(':');
    if (idx <= 0) continue;
    final String key = trimmed.substring(0, idx).trim();
    final String value = trimmed.substring(idx + 1).trim();
    out[key] = value.replaceAll(RegExp('^["\']|["\']\$'), '');
  }
  return out;
}

String? _str(Object? v) => v == null
    ? null
    : v.toString().trim().isEmpty
    ? null
    : v.toString().trim();

Future<void> _updateAndroidIds(String appId) async {
  final File gradle = File('android/app/build.gradle.kts');
  if (await gradle.exists()) {
    String txt = await gradle.readAsString();
    txt = txt.replaceAll(
      RegExp(r'namespace\s*=\s*"[^"]+"'),
      'namespace = "$appId"',
    );
    txt = txt.replaceAll(
      RegExp(r'applicationId\s*=\s*"[^"]+"'),
      'applicationId = "$appId"',
    );
    await gradle.writeAsString(txt);
    stdout.writeln('Updated Android applicationId/namespace → $appId');
  } else {
    stderr.writeln('Android build.gradle.kts not found.');
  }
}

Future<void> _updateAndroidAppName(String appName) async {
  final File manifest = File('android/app/src/main/AndroidManifest.xml');
  if (await manifest.exists()) {
    String txt = await manifest.readAsString();
    if (txt.contains('android:label=')) {
      txt = txt.replaceAll(
        RegExp(r'android:label="[^"]*"'),
        'android:label="$appName"',
      );
      await manifest.writeAsString(txt);
      stdout.writeln('Updated Android label → $appName');
    }
  } else {
    stderr.writeln('AndroidManifest.xml not found.');
  }
}

/// Ensure AndroidManifest's activity android:name matches the actual
/// package declared in MainActivity.(kt|java). This avoids launch issues
/// when applicationId/namespace differ from the Activity's package.
Future<void> _syncAndroidMainActivityName() async {
  final Directory kotlinDir = Directory('android/app/src/main/kotlin');
  if (!await kotlinDir.exists()) {
    // Kotlin directory not found; nothing to do.
    return;
  }

  File? mainActivityFile;
  await for (final FileSystemEntity entity in kotlinDir.list(
    recursive: true,
    followLinks: false,
  )) {
    if (entity is File &&
        (entity.path.endsWith('MainActivity.kt') ||
            entity.path.endsWith('MainActivity.java'))) {
      mainActivityFile = entity;
      break;
    }
  }

  if (mainActivityFile == null) {
    stderr.writeln('MainActivity not found under android/app/src/main/kotlin.');
    return;
  }

  final String mainSrc = await mainActivityFile.readAsString();
  final RegExp pkgRe = RegExp(
    r'^\s*package\s+([a-zA-Z0-9_.]+)',
    multiLine: true,
  );
  final RegExpMatch? m = pkgRe.firstMatch(mainSrc);
  if (m == null) {
    stderr.writeln('Could not detect package from MainActivity.');
    return;
  }
  final String activityFqcn = '${m.group(1)}.MainActivity';

  final File manifest = File('android/app/src/main/AndroidManifest.xml');
  if (!await manifest.exists()) {
    stderr.writeln('AndroidManifest.xml not found.');
    return;
  }

  String manifestTxt = await manifest.readAsString();
  final RegExp nameAttr = RegExp(
    'android:name\\s*=\\s*["\\\'][^"\\\']*MainActivity["\\\']',
  );
  if (!nameAttr.hasMatch(manifestTxt)) {
    // If not present in expected form, do not modify further.
    stderr.writeln('android:name for MainActivity not found in manifest.');
    return;
  }
  manifestTxt = manifestTxt.replaceAll(
    nameAttr,
    'android:name="$activityFqcn"',
  );
  await manifest.writeAsString(manifestTxt);
  stdout.writeln('Synced AndroidManifest activity name → $activityFqcn');
}

Future<void> _updateIosBundleId(String bundleId) async {
  final File pbx = File('ios/Runner.xcodeproj/project.pbxproj');
  if (await pbx.exists()) {
    String txt = await pbx.readAsString();
    txt = txt.replaceAll(
      RegExp(r'PRODUCT_BUNDLE_IDENTIFIER\s*=\s*[^;]+;'),
      'PRODUCT_BUNDLE_IDENTIFIER = $bundleId;',
    );
    await pbx.writeAsString(txt);
    stdout.writeln('Updated iOS PRODUCT_BUNDLE_IDENTIFIER → $bundleId');
  } else {
    stderr.writeln('iOS project.pbxproj not found.');
  }
}

Future<void> _updateIosAppName(String appName) async {
  final File plist = File('ios/Runner/Info.plist');
  if (await plist.exists()) {
    String txt = await plist.readAsString();
    txt = txt.replaceAll(
      RegExp(r'<key>CFBundleDisplayName<\/key>\s*<string>[^<]*<\/string>'),
      '<key>CFBundleDisplayName</key>\n\t<string>$appName</string>',
    );
    txt = txt.replaceAll(
      RegExp(r'<key>CFBundleName<\/key>\s*<string>[^<]*<\/string>'),
      '<key>CFBundleName</key>\n\t<string>${_plistSanitize(appName)}</string>',
    );
    await plist.writeAsString(txt);
    stdout.writeln('Updated iOS display/name → $appName');
  } else {
    stderr.writeln('iOS Info.plist not found.');
  }
}

String _plistSanitize(String v) {
  // Bundle name should be simple (avoid spaces if desired); we keep as-is here.
  return v;
}

Future<void> _updateWebTitle(String title) async {
  final File indexHtml = File('web/index.html');
  if (await indexHtml.exists()) {
    String txt = await indexHtml.readAsString();
    txt = txt.replaceAll(
      RegExp(r'<title>[^<]*<\/title>'),
      '<title>$title</title>',
    );
    await indexHtml.writeAsString(txt);
    stdout.writeln('Updated web/index.html title → $title');
  }
  final File manifest = File('web/manifest.json');
  if (await manifest.exists()) {
    final Map<String, dynamic> json =
        jsonDecode(await manifest.readAsString()) as Map<String, dynamic>;
    json['name'] = title;
    json['short_name'] = title;
    await manifest.writeAsString(
      const JsonEncoder.withIndent('  ').convert(json),
    );
    stdout.writeln('Updated web/manifest.json name/short_name → $title');
  }
}
