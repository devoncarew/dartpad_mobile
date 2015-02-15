// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library dart_pad.grind;

import 'dart:async';
import 'dart:io';

import 'package:grinder/grinder.dart';
import 'package:librato/librato.dart';

void main(List<String> args) {
  task('init', defaultInit);
  task('build', build, ['init']);
  task('deploy', deploy, ['build']);
  task('clean', defaultClean);

  task('default', null, ['build']);

  startGrinder(args);
}

/// Build the `web/index.html` entrypoint.
build(GrinderContext context) {
  Pub.build(context, directories: ['web']); //, 'test']);

  File outFile = joinFile(BUILD_DIR, ['web', 'main.dart.js']);
  //File testFile = joinFile(BUILD_DIR, ['test', 'web.dart.js']);
  context.log('${outFile.path} compiled to ${_printSize(outFile)}');
  //context.log('${testFile.path} compiled to ${_printSize(testFile)}');

  // Delete the build/web/packages directory.
  deleteEntity(getDir('build/web/packages'));

  // Reify the symlinks.
  // cp -R -L packages build/web/packages
  runProcess(context, 'cp',
      arguments: ['-R', '-L', 'packages', 'build/web/packages']);

  // Run vulcanize.
  File indexFile = joinFile(BUILD_DIR, ['web', 'index.html']);
  context.log('${indexFile.path} original: ${_printSize(indexFile)}');
  runProcess(context,
      'vulcanize', // '--csp', '--inline',
      arguments: ['--strip', '--output', 'index.html', 'index.html'],
      workingDirectory: 'build/web');
  context.log('${indexFile.path} vulcanize: ${_printSize(indexFile)}');

  return _uploadCompiledStats(context, outFile.lengthSync());
}

/// Prepare the app for deployment.
void deploy(GrinderContext context) {
  context.log('execute: `firebase deploy`');
}

Future _uploadCompiledStats(GrinderContext context, num length) {
  Map env = Platform.environment;

  if (env.containsKey('LIBRATO_USER') && env.containsKey('TRAVIS_COMMIT')) {
    Librato librato = new Librato.fromEnvVars();
    context.log('Uploading stats to ${librato.baseUrl}');
    LibratoStat compiledSize = new LibratoStat('main.dart.js', length);
    return librato.postStats([compiledSize]).then((_) {
      String commit = env['TRAVIS_COMMIT'];
      LibratoLink link = new LibratoLink(
          'github',
          'https://github.com/devoncarew/dartpad_mobile/commit/${commit}');
      LibratoAnnotation annotation = new LibratoAnnotation(
          commit,
          description: 'Commit ${commit}',
          links: [link]);
      return librato.createAnnotation('build_mobile_ui', annotation);
    });
  } else {
    return new Future.value();
  }
}

String _printSize(File file) => '${(file.lengthSync() + 1023) ~/ 1024}k';
